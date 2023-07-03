import 'package:wallpaper_task/model/categories_model.dart';

String apiKey = "U1FGx03eRsXXnj02vudW4nOo0otayy5GjGxplM6rKHoCDlMzuBTtRLSL";
List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [];
  CategoriesModel categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg";
  categoriesModel.categoriesName = "Nature";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg";
  categoriesModel.categoriesName = "Sky";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg";
  categoriesModel.categoriesName = "Coading";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg";
  categoriesModel.categoriesName = "Food";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  return categories;
}
