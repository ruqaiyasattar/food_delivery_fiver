import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/Dish_list.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/ui/widgets/product_tile.dart';
import 'package:provider/provider.dart';
import '../shared/text_styles.dart' as style;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../locator.dart';
import 'itemDetails.dart';

class FavoriteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: <Widget>[
          Consumer<FavouriteProducts>(
            builder: (context, favourite, child) {
              return Expanded(
                child: ListView.builder(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: favourite.products.length,
                  itemBuilder: (context, index) {
                    return ProductTileWidget(
                      Provider.of<FavouriteProducts>(context,listen: true),
                      product: favourite.products[index],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}

