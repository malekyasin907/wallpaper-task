import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_task/model/wallpaper_model.dart';
import 'package:wallpaper_task/views/category.dart';
import 'package:wallpaper_task/views/favorite.dart';
import 'package:wallpaper_task/views/search.dart';
import 'package:wallpaper_task/widget/widget.dart';
import 'package:wallpaper_task/model/categories_model.dart';
import 'package:wallpaper_task/data/data.dart';
import 'package:http/http.dart' as http;

import '../data/sqflite_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = [];
  List<WallPaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();

  getTrendWallpapers() async {
    var url = Uri.parse("https://api.pexels.com/v1/curated?per_page=15");
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
    getTrendWallpapers();
    categories = getCategories();
    readData();
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Favorite(),
            ));
          },
          child: Icon(Icons.favorite)),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "search", border: InputBorder.none),
                    )),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Search(searchQuery: searchController.text),
                              ));
                        },
                        child: Container(child: Icon(Icons.search)))
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                    itemCount: categories.length,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoriesTile(
                          imgUrl: categories[index].imgUrl,
                          title: categories[index].categoriesName);
                    }),
              ),
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

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;
  const CategoriesTile({super.key, required this.imgUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(title.toLowerCase());

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Categories(categoryName: title.toLowerCase()),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8)),
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
