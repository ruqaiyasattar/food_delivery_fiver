import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopularProducts extends ChangeNotifier{
  SharedPreferences preferences;
  List<Product> products;
  PopularProducts(){
    products=List();
    getProductsList();
  }

  void getProductsList() async{
//    SharedPreferences preferences=await SharedPreferences.getInstance();
//    products=await Database.getInstance().getLatestMenuItems();
//
//    for( Product p in products){
//      p.liked=preferences.getBool(p.id)??false;
//    }
//    notifyListeners();
  }
}