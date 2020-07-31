import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/category.dart';

class CategoryList extends ChangeNotifier{
  List<Category> categories;

  CategoryList(){
    categories=List();
    getProductsList();
  }

  void getProductsList() async{
    categories=await Database.getInstance().getCategories();
    notifyListeners();
  }
}