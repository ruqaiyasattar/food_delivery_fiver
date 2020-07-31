import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/popular_products.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import '../shared/text_styles.dart' as style;
import 'package:provider/provider.dart';
import '../../core/Dish_list.dart';
import './PopularItem.dart' ;

class PopularItemListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double itemHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 16, top: 32),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Piatti Popolari",
                  style: style.headerStyle2,
                ),
              ),
//              InkWell(
//                onTap: () {},
//                child: Text(
//                  "View More",
//                  style: style.subHeaderStyle
//                      .copyWith(color: Theme.of(context).primaryColor),
//                ),
//              )
            ],
          ),
        ),
        Consumer<ProductList>(
          builder: (context, model, child) {
            print('PopularItems:${model.popularProducts.length}');
            final double itemHeight =
                (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 2;
            final double itemWidth = MediaQuery.of(context).size.width / 1.7;
            return GridView.builder(
              padding: EdgeInsets.only(bottom:32),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 8
              ),
              itemCount: model.popularProducts.length>10?10:model.popularProducts.length,
              itemBuilder: (context, index) {
                return PopularItem(product : model.popularProducts[index]) ;
              },
            );
          },
        )
      ],
    );
  }
}


