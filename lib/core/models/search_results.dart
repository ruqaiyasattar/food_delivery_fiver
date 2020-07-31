import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResults extends ChangeNotifier{
//  SharedPreferences preferences;
  List<Product> products;
  List<Product> searchResult;
  SearchResults(List<Product> products){
    this.products=products;
    print('products.length:${products.length}');
    searchResult=List();
  }

  Future performSearch(String search) async {
    searchResult.clear();
    if(search==null||search.isEmpty){
      notifyListeners();
      return;
    }
    search=search?.toLowerCase();
    print('searching:${products.length}');
    int i=0;
    for(Product p in products){
      print('iteration:$i');
      if(p.name==null||p.category==null)continue;
      if(p.name.toLowerCase().contains(search)
//      || p.description.toLowerCase().contains(search)
      || p.category.toLowerCase().contains(search)){
        searchResult.add(p);
      }
    }
    print('performSearch:$search found:${searchResult.length}');
    notifyListeners();
  }
}