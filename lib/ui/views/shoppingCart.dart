import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/ui/views/PaymentPage.dart';
import 'package:food_delivery_app/ui/views/card_create.dart';
import '../widgets/cartItemCard.dart';
import '../shared/text_styles.dart' as style;
import 'package:provider/provider.dart';

class ShoppingCartView extends StatefulWidget {
  @override
  _ShoppingCartViewState createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {
  double price;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Consumer<ShoppingCart>(
      builder: (_,cart,__){
        return Scaffold(
          bottomNavigationBar: Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              height: 100,
              width: MediaQuery.of(context).size.width * 0.85,
              color: Theme.of(context).cardColor,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Totale: ',
                            style: style.cardTitleStyle,
                          ),
                          Text(
                            '€ ${cart.getPrice()}',
                            style: style.cardTitleStyle
                                .copyWith(color: Theme.of(context).primaryColor),
                          ),
                          Text('Spese spedizione incluse')
                        ],
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 65,
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: cart.getProductsList().length==0?null:() {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context)=>PaymentPage(shoppingCart: cart)));//pushNamed(context, '/paymentPage') ;
                          },
                          elevation: 0.5,
                          color: Theme.of(context).primaryColor,
                          child: Center(
                            child: Text(
                              'INVIA ORDINE',
                            ),
                          ),
                          textColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            //physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                    ),
                    Positioned(
                      bottom: deviceSize.height * 0.05,
                      right: deviceSize.width * 0.4,
                      child: Container(
                        height: deviceSize.width,
                        width: deviceSize.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: deviceSize.height * 0.1,
                      left: deviceSize.width * 0.5,
                      child: Container(
                          height: deviceSize.width * 0.65,
                          width: deviceSize.width * 0.65,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150.0),
                              color: Colors.white.withOpacity(0.1))),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: IconButton(
                                  alignment: Alignment.topLeft,
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            Text(
                              'Carrello',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                    offset: Offset(0, -deviceSize.height * 0.15),
                    child: ListView.builder(
                      itemCount: cart.getProductsList().length==0?1:cart.getProductsList().length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if(cart.getProductsList().length==0){
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Il carrello è vuoto",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                        Product product = cart.getProductsList()[index];
                        return CartItemCard(product: product);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
