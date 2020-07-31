import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends ChangeNotifier{


  List<Product> products;
  List<Product> favouriteProducts;
  List<Product> latestProducts;
  List<Product> popularProducts;
  List<String> latestProductsId;
  List<String> popularProductsId;
//  List<Product> latestProducts;

  ProductList(){
    getProductsList();
  }

  Future<ProductList> getProductsList() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    List<DocumentSnapshot> list=await Database.getInstance().getAllProducts();
    products=List();
    favouriteProducts=List();
    popularProductsId=List();
    latestProductsId=List();
    popularProducts=List();
    latestProducts=List();
    for(var doc in list){
      print('getAllProducts:${doc.documentID}');
      if(doc.documentID=='popular_products'){
        print(doc.data["products"]);
        for(String s in doc.data["products"]){
          print('popular_products:$s');
          popularProductsId.add(s);
        }
      }else if(doc.documentID=='latest_products'){
        print(doc.data["products"]);
        for(String s in doc.data["products"]){
          print("latestProducts:$s");
          latestProductsId.add(s);
        }
      }else{
        Product p=Product().from(doc);
        p.liked=preferences.getBool(p.id)??false;
        products.add(p);
      }
    }
    print('latestProductsIdList:$latestProductsId');
    print('popularProductsIdList:$popularProductsId');
    for(Product p in products){
      for(String id in latestProductsId){
        print('comparing:$id with ${p.id}:${id.contains(p.id)}');
        if(id.contains(p.id)) {
          print('latestProductAdded:$id');
          latestProducts.add(p);
        }
      }
      for(String id in popularProductsId){
        print('comparing:$id with ${p.id}:${id.contains(p.id)}');
        if(id.contains(p.id)) {
          print('popularProductAdded:$id');
          popularProducts.add(p);
        }
      }
    }
//    notifyListeners();
    return this;
  }

  List<Product> getProductsByCategory(String id) {
    List<Product> categoryProducts=List();
    for(Product p in products){
      print("${p.categoryID} | ${id}:${p.id.toLowerCase().contains(id.toLowerCase())}");
      if(p.categoryID.toLowerCase().compareTo(id.toLowerCase())==0){
        categoryProducts.add(p);
      }
    }
    return categoryProducts;
  }
}