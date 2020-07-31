import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteProducts extends ChangeNotifier{
  SharedPreferences preferences;
  List<Product> products;
  List<Product> allProducts;
  FavouriteProducts(List<Product> allProducts){
    products=List();
    this.allProducts=allProducts;
    getProductsList();
  }

  void addProduct(String id)async{
    if(preferences==null)
      preferences=await SharedPreferences.getInstance();
    for(Product p in allProducts){
      if(p.id==id){
        preferences.setBool(id, true);
        products.add(p);
      }
    }
    notifyListeners();
  }

  void removeProduct(String id)async{
    if(preferences==null)
      preferences=await SharedPreferences.getInstance();
    for(Product p in products){
      if(p.id==id){
        preferences.setBool(id, false);
        products.remove(p);
      }
    }
    notifyListeners();
  }

  void getProductsList() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    for( Product p in allProducts){
      p.liked=preferences.getBool(p.id)??false;
      if(p.liked){
        products.add(p);
      }
    }
    notifyListeners();
  }
}