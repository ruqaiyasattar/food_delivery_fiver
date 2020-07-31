import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/category_list.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/latest_products.dart';
import 'package:food_delivery_app/core/models/popular_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/ui/widgets/product_tile.dart';
import '../widgets/LatestProductList.dart';
import 'package:provider/provider.dart';
import '../../locator.dart';
import '../../core/Dish_list.dart';
import '../widgets/categories.dart';
import '../widgets/popularItems.dart';


class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool showProductList=false;
  List<Product> productsToDisplay;

  void setProductsToDisplay(List<Product> products){
    productsToDisplay=products;
    setState(() {
      showProductList=true;
    });
    print("setProductsToDisplay:${productsToDisplay.length}");
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<FoodList>(
      create: (context) => locator<FoodList>(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12 ),
        child: Stack(
          children: <Widget>[
            showProductList?Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                shrinkWrap: true,
                itemCount: productsToDisplay.length,//productList.products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric( horizontal: 4.0),
                    child: ProductTileWidget(
                      Provider.of<FavouriteProducts>(context,listen: false),
                      product: productsToDisplay[index],
                    ),
                  );
                },
              ),
            ):ListView(
              children: <Widget>[
                LatestProductListView(),
                CategoriesView(setProductsToDisplay),
                PopularItemListView(),
              ],
            ),
//            showProductList?:Container(),
          ],
        ),
      ),
    );
  }
}
