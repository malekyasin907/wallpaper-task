import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/data.dart';
import '../model/wallpaper_model.dart';
import 'package:http/http.dart' as http;

import '../widget/widget.dart';

class Categories extends StatefulWidget {
  final String? categoryName;
  const Categories({super.key, this.categoryName});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<WallPaperModel> wallpapers = [];

  getSearchWallpapers(String query) async {
    var url =
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=15");
    var response = await http.get(url, headers: {"Authorization": apiKey});

    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallPaperModel wallpaperModel = WallPaperModel();
      wallpaperModel = WallPaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    // to recrete whole screen with newly update
    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.categoryName ?? "");
    super.initState();
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              wallpaperList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
