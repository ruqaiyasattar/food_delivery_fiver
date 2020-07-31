import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import '../shared/text_styles.dart' as style;
import 'package:provider/provider.dart';
import '../views/itemDetails.dart';

class LatestProductListView extends StatefulWidget {
  @override
  _LatestProductListViewState createState() => _LatestProductListViewState();
}

class _LatestProductListViewState extends State<LatestProductListView> {
  final PageController ctrl = PageController(viewportFraction: 0.8);

  int currentPage = 0;
  _buildStoryPage(Product product, bool active,context) {
    // Animated Properties
    final double blur = active ? 7 : 0;
    final double offset = active ? 10 : 0;
    final double top = active ? 10 : 50;


    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            FavouriteProducts favouriteProducts=Provider.of<FavouriteProducts>(context,listen: false);
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ItemDetails(product: product,favouriteProducts: favouriteProducts,))) ;
          },
          child: Hero(
            transitionOnUserGestures: true,
            tag:product.id ,
            child: AnimatedContainer(
              width: MediaQuery.of(context).size.width *0.7,
              height: MediaQuery.of(context).size.height *0.45 - top - 7 - 8,
              duration: Duration(milliseconds: 700),
              curve: Curves.easeOutQuint,
              margin: EdgeInsets.only(top: top, bottom: 15, right: MediaQuery.of(context).size.width *0.1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(product.images[0]),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: blur, offset: Offset(offset, offset))]
              ),

            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width *0.1),
          height: MediaQuery.of(context).size.height *0.07,
          child: Row(
            mainAxisSize: MainAxisSize.max ,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${product.name}',style: style.cardTitleStyle.copyWith(color: Theme.of(context).primaryColor),),
                  SizedBox(height: 1,),
                  Text('${product.category}',style: style.subcardTitleStyle,)
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 7),
                  child: Text('€${product.price}',style: style.cardTitleStyle.copyWith(color: Colors.white),),
              )
            ],
          ),
        )
      ],
    );
  }
  @override
  void initState() {
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if(currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Più recenti",
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
          builder: (context,productList,child){
            print('LatestProductList:${productList.latestProducts.length}');
            return Container(
              height: MediaQuery.of(context).size.height* 0.52,
              child: PageView.builder(
                controller: ctrl,
                itemCount: productList.latestProducts.length>10?10:productList.latestProducts.length,
                itemBuilder: (context,index){
                  bool active = index == currentPage;
                  return _buildStoryPage(productList.latestProducts[index],active,context) ;
                },
              ),
            );
          },
        )
      ],
    );
  }
}
