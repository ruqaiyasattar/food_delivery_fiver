import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/category_list.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/core/models/user.dart';
import 'package:food_delivery_app/ui/views/mainHome.dart';
import 'package:provider/provider.dart';

class MainHomeWrapper extends StatelessWidget {
  final ProductList productList;

  const MainHomeWrapper({Key key, this.productList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductList>(create: (context)=>productList,),
        ChangeNotifierProvider<UserModel>(create: (context)=>UserModel(),),
        ChangeNotifierProvider<FavouriteProducts>(create: (context)=>FavouriteProducts(productList.products),),
        ChangeNotifierProvider<CategoryList>(create: (context) => CategoryList(),),
      ],
      child: MainHome(),
    );
  }
}
