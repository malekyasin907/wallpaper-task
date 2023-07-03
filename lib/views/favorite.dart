import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_task/views/image.dart';

import '../data/data.dart';
import '../data/sqflite_data.dart';
import '../model/wallpaper_model.dart';
import '../widget/widget.dart';
import 'package:http/http.dart' as http;

class Favorite extends StatefulWidget {
  final String? searchQuery;
  const Favorite({super.key, this.searchQuery});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  TextEditingController searchController = TextEditingController();

  // List<CategoriesModel> categories = [];
  // List<WallPaperModel> wallpapers = [];

  // getSearchWallpapers(String query) async {
  //   var url =
  //       Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=15");
  //   var response = await http.get(url, headers: {"Authorization": apiKey});

  //   // print(response.body.toString());

  //   Map<String, dynamic> jsonData = jsonDecode(response.body);
  //   jsonData["photos"].forEach((element) {
  //     WallPaperModel wallpaperModel = WallPaperModel();
  //     wallpaperModel = WallPaperModel.fromMap(element);
  //     wallpapers.add(wallpaperModel);
  //   });

  //   // to recrete whole screen with newly update
  //   setState(() {});
  // }

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
    // getSearchWallpapers(widget.searchQuery ?? "");
    readData();
    super.initState();
    searchController.text = widget.searchQuery ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BrandName(),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          child: isLoading
              ? Center(child: Text("Loading ...."))
              : Container(
                  child: Column(
                    children: [
                      Center(
                        child: MaterialButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () async {
                            await SqlDb().myDeleteData();
                          },
                          child: Text("Remove All"),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Set the number of columns
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: notes.length,
                          itemBuilder: (context, i) {
                            return GridTile(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageView(
                                        imgUrl: notes[i]['url'],
                                      ),
                                    ));
                              },
                              child: Hero(
                                tag: notes[i]['url'],
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      notes[i]['url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                )

          // Container(
          //     child: Column(
          //       children: [
          //         Center(
          //           child: MaterialButton(
          //             color: Colors.red,
          //             textColor: Colors.white,
          //             onPressed: () async {
          //               await sqlDb.myDeleteData();
          //             },
          //             child: Text("Remove All"),
          //           ),
          //         ),
          //         Expanded(
          //           child: ListView(
          //             children: [
          //               ListView.builder(
          //                   itemCount: notes.length,
          //                   physics: NeverScrollableScrollPhysics(),
          //                   shrinkWrap: true,
          //                   itemBuilder: (context, i) {
          //                     return Card(
          //                         child: ListTile(
          //                       title: Text("${notes[i]['url']}"),
          //                     ));
          //                   })
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          ),
    );
  }
}
