import 'package:flutter/material.dart';
import 'package:wallpaper_task/model/wallpaper_model.dart';
import 'package:wallpaper_task/views/image.dart';

Widget BrandName() {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      children: const <TextSpan>[
        TextSpan(text: 'WallPaper', style: TextStyle(color: Colors.black)),
        TextSpan(text: ' Hub', style: TextStyle(color: Colors.blue)),
      ],
    ),
  );
}

Widget wallpaperList({List<WallPaperModel>? wallpapers, context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: .6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers?.map((wallpaper) {
            return GridTile(
                child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageView(
                        imgUrl: wallpaper.src?.portrait ?? '',
                      ),
                    ));
              },
              child: Hero(
                tag: wallpaper.src?.portrait ?? '',
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      wallpaper.src?.portrait ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ));
          }).toList() ??
          [],
    ),
  );
}
