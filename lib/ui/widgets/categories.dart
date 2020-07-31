import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/category.dart';
import 'package:food_delivery_app/core/models/category_list.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/ui/views/product_list_view.dart';
import '../shared/text_styles.dart' as style;
import 'package:provider/provider.dart';
import '../../core/Dish_list.dart';


class CategoriesView extends StatelessWidget {

  final Function viewCategory;

  CategoriesView(this.viewCategory);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(bottom: 16,top: 24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                "Categorie",
                style: style.headerStyle2,
              ),
            ),
            InkWell(
              onTap: () {
                List<Product> filteredProducts=Provider.of<ProductList>(context).products;
                FavouriteProducts favProducts=Provider.of<FavouriteProducts>(context);
                ProductListView productListView=ProductListView(
                  title: "Tutti i prodotti",
                  products: filteredProducts,
                  favouriteProducts: favProducts,
                );
                Navigator.push(context, MaterialPageRoute(builder: (_)=> productListView)) ;
              },
              child: Text(
                "Guarda tutti i prodotti",
                style: style.subHeaderStyle
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            )
          ],
        ),
      ),
      Consumer<CategoryList>(
        builder: (context,model,child) {
          return  Container(
            height: MediaQuery.of(context).size.height/6,
            child: ListView.builder(
              primary: false,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: model.categories.length,
              itemBuilder: (BuildContext context, int index) {
                Category cat = model.categories[index];

                return GestureDetector(
                  onTap: (){
                    List<Product> filteredProducts=Provider.of<ProductList>(context).getProductsByCategory(cat.id);
                    FavouriteProducts favProducts=Provider.of<FavouriteProducts>(context);
                    ProductListView productListView=ProductListView(
                      title: cat.name,
                      products: filteredProducts,
                      favouriteProducts: favProducts,
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> productListView)) ;
//                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>));
//                    viewCategory(Provider.of<ProductList>(context).getProductsByCategory(cat.id));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            cat.img,
                            height: MediaQuery.of(context).size.height/6,
                            width: MediaQuery.of(context).size.height/6,
                            fit: BoxFit.cover,
                          ),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                // Add one stop for each color. Stops should increase from 0 to 1
                                stops: [0.2, 0.7],
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(100, 0, 0, 0),
                                ],
                                // stops: [0.0, 0.1],
                              ),
                            ),
                            height: MediaQuery.of(context).size.height/6,
                            width: MediaQuery.of(context).size.height/6,
                          ),

                          Center(

                            child: Container(
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.height/6,
                              padding: EdgeInsets.all(1),
                              constraints: BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  cat.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

    ],);
  }
}
