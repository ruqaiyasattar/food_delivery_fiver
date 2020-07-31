import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/models/product.dart';

class ShoppingCart extends ChangeNotifier{
  List<Product> _products;
  double _price;

  ShoppingCart(){
    _products=List();
    _price=0;
  }

  void increaseQuantity(Product product){
    product.quantity++;
    notifyListeners();
  }
  void decreaseQuantity(Product product){
    product.quantity--;
    notifyListeners();
  }

  void addProduct(Product product)async{
    if(_products.contains(product))return;
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product)async{
    _products.remove(product);
    notifyListeners();
  }

  double getPrice(){
    _price=0;
    for(Product p in _products) {
      print('before:$_price');
      _price += p.price * p.quantity;
      print('after:$_price');

    }
    return _price;
  }

  List<Product> getProductsList(){
    return _products;
  }

  void clear() {
    _products.clear();
    _price=0;
  }
}