import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/ui/widgets/product_tile.dart';

class ProductListView extends StatelessWidget {

  final List<Product> products;
  final String title;
  final FavouriteProducts favouriteProducts;


  const ProductListView({Key key, this.favouriteProducts,this.products, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    print(products.length)

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title,style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          shrinkWrap: true,
          itemCount: products.length,//productList.products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric( horizontal: 4.0),
              child: ProductTileWidget(
                favouriteProducts,
                product: products[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
