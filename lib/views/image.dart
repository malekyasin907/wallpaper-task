import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/sqflite_data.dart';

class ImageView extends StatefulWidget {
  final String? imgUrl;
  const ImageView({super.key, this.imgUrl});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  SqlDb sqlDb = SqlDb();
  bool isLoading = true;
  List notes = [];

  Future readData() async {
    List<Map> response = await sqlDb.read("notes");
    notes.addAll(response);
    isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    readData();
    super.initState();
  }

  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
              tag: widget.imgUrl ?? "",
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imgUrl ?? "",
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _saveImage(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            color: Color(0xff1c1b1b).withOpacity(.8),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              Color(0x36ffffff),
                              Color(0x0fffffff)
                            ])),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Download",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      int response = await SqlDb().insert("notes", {
                        "url": "${widget.imgUrl.toString()}",
                      });
                      if (response > 0) {
                        print("add to favoritr ---------");
                      }
                    } catch (e) {
                      print("already added");
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            color: Color(0xff1c1b1b).withOpacity(.8),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              Color(0x36ffffff),
                              Color(0x0fffffff)
                            ])),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Add to favorite",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    if (Platform.isAndroid) {
      await _askPermission();
    }
    var response = await Dio().get(widget.imgUrl ?? "",
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      var permission = await Permission.photos.request();
    } else {
      PermissionStatus permission = await Permission.storage.request();
    }
  }

  // void _saveImage() async {
  //   // Request permission
  //   PermissionStatus status = await Permission.photos.request();

  //   if (status.isGranted) {
  //     try {
  //       // Fetch image data
  //       var response = await Dio().get(
  //         widget.imgUrl ?? "",
  //         options: Options(responseType: ResponseType.bytes),
  //       );
  //       Uint8List imageData = Uint8List.fromList(response.data);

  //       // Save image to gallery
  //       await ImageGallerySaver.saveImage(imageData);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Image saved successfully')),
  //       );
  //     } catch (e) {
  //       print('Error saving image: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to save image')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Permission denied')),
  //     );
  //   }
  // }

  Future<void> _saveImage(BuildContext context) async {
    // Request permission to access the photos
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      try {
        // Fetch image data
        var response = await Dio().get(
          widget.imgUrl ?? "",
          options: Options(responseType: ResponseType.bytes),
        );
        Uint8List imageData = Uint8List.fromList(response.data);

        // Save image to gallery
        await ImageGallerySaver.saveImage(imageData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved successfully')),
        );
      } catch (e) {
        print('Error saving image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied')),
      );
    }
  }
}
