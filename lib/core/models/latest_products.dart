import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product.dart';

class LatestProducts extends ChangeNotifier{
  List<Product> products;

  LatestProducts(){
    products=List();
    getProductsList();
  }

  void getProductsList() async{
//    products=await Database.getInstance().getLatestMenuItems();
    notifyListeners();
  }
}