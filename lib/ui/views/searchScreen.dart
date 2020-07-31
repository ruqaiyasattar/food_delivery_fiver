import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/core/models/search_results.dart';
import 'package:food_delivery_app/ui/widgets/product_tile.dart';
import 'package:provider/provider.dart';
import '../shared/text_styles.dart' as style;

class SearchPanel extends StatelessWidget {

  SearchResults searchResults;

  @override
  Widget build(BuildContext context) {
    List<Product> products=Provider.of<ProductList>(context,listen: false).products;
    searchResults=SearchResults(products);

    return ChangeNotifierProvider<SearchResults>(
      create: (context)=>searchResults,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 10.0),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(25.0),
                child: TextFormField(
                  onChanged: (val){
//                    searchResults.performSearch(val);
                    searchResults.performSearch(val);
                    print("onChanged:$val");
                  },
                  onFieldSubmitted: (val){
                    searchResults.performSearch(val);
                    print("onFieldSubmitted:$val");
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      contentPadding:
                      EdgeInsets.only(left: 15.0, top: 15.0),
                      hintText: 'Cerca',
                      hintStyle: TextStyle(color: Theme.of(context).hintColor)),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Consumer<SearchResults>(
              builder: (context, searchResults, child) {
                print("searchRebuilt");
                return Expanded(
                  child: searchResults.searchResult.length==0?Center(
                    child:Text("Nessuna ricerca trovata"),
                  ):ListView.builder(
                    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: searchResults.searchResult.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric( horizontal: 16.0),
                        child: ProductTileWidget(
                          Provider.of<FavouriteProducts>(context,listen: false),
                          product: searchResults.searchResult[index],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

//  Widget _foodCard() {
//    return Container(
//      height: 125.0,
//      width: 250.0,
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(12.0),
//        color: Theme.of(context).cardColor,
//      ),
//      child: Row(
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(12.0),
//                image:
//                DecorationImage(image: AssetImage('assets/food8.jpg'),fit: BoxFit.fill)),
//            height: 125.0,
//            width: 100.0,
//          ),
//          SizedBox(width: 20.0),
//          Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                'Grilled Chicken',
//                style: TextStyle(fontFamily: 'Quicksand'),
//              ),
//              Text(
//                'with Fruit Salad',
//                style: TextStyle(fontFamily: 'Quicksand'),
//              ),
//              SizedBox(height: 10.0),
//              Container(
//                height: 2.0,
//                width: 75.0,
//                color: Theme.of(context).primaryColor,
//              ),
//              SizedBox(height: 10.0),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Container(
//                    height: 25.0,
//                    width: 25.0,
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(12.5),
//                        image: DecorationImage(
//                            image: AssetImage('assets/profil.jpg'))),
//                  ),
//                  SizedBox(width: 10.0),
//                  Text('James Oliver',
//                      style: TextStyle(fontFamily: 'Quicksand'))
//                ],
//              )
//            ],
//          )
//        ],
//      ),
//    );;
//  }
}
