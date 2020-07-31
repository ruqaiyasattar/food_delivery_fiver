import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/helpers/mask_text_input_formatter.dart';
import 'package:food_delivery_app/core/helpers/validators.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:food_delivery_app/ui/views/card_create.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/card_list_model.dart';
import '../../core/models/card_model.dart';
import '../widgets/card_chip.dart';
import '../widgets/card_logo.dart';
import 'package:provider/provider.dart';
import '../widgets/titleAppBar.dart';
import '../shared/text_styles.dart' as style;

class PaymentPage extends StatefulWidget {
  final ShoppingCart shoppingCart;

  const PaymentPage({Key key, this.shoppingCart}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final int LOADING = 0, FOUND = 1, NOT_FOUND = 2;
  final couponCode = TextEditingController();

  int cardAvailable = 0;
  int couponApplied = 2;
  DocumentSnapshot discount;
  String last4;
  String email;
  @override
  void initState() {
    loadCardDetails();
    super.initState();
  }

//add by Numan
  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void loadCardDetails() async {
    // load email
    email = (await Auth().currentUser()).email;

    String uid = (await Auth().currentUser()).uid;
    Database.getInstance(uid: uid).listenForSources().listen((data) {
      for (DocumentSnapshot d in data.documents) {
        print("source:${d.data.toString()}");
      }
      if (data.documents.length == 0) {
        setState(() {
          cardAvailable = NOT_FOUND;
        });
      } else {
        var ds = data.documents[0].data;
        setState(() {
          cardAvailable = FOUND;
          last4 = ' ${ds['last4']}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CardListModelView cardlistProvided =
        Provider.of<CardListModelView>(context);
    final cardForm = CardForm(
      formKey: Validators.KEY,
      card: StripeCard(),
    );
    return Scaffold(
      appBar: TitleAppBar(title: "Checkout"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.shoppingCart.getProductsList().length + 2,
                  itemBuilder: (ctx, index) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: index == 0
                          ? <Widget>[
                              Flexible(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Nome",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Quantità",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Prezzo",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                ),
                              ),
                            ]
                          : index ==
                                  widget.shoppingCart.getProductsList().length +
                                      1
                              ? discount == null
                                  ? <Widget>[
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "Totale",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          margin: EdgeInsets.all(8.0),
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "${widget.shoppingCart.getPrice()}€",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          margin: EdgeInsets.all(8.0),
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                    ]
                                  : <Widget>[
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "Sconto",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          margin: EdgeInsets.all(8.0),
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              discount.data['type'] == "Percent"
                                                  ? "${discount.data['valueoff']}%"
                                                  : "${discount.data['valueoff']}€",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          margin: EdgeInsets.all(8.0),
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "Totale",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          margin: EdgeInsets.all(8.0),
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              discount.data['type'] == "Percent"
                                                  ? "${(int.parse(discount.data['valueoff']) / 100) * widget.shoppingCart.getPrice()}€"
                                                  : "${widget.shoppingCart.getPrice() - int.parse(discount.data['valueoff'])}€",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          margin: EdgeInsets.all(8.0),
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                    ]
                              : <Widget>[
                                  Flexible(
                                    child: Container(
                                      child: Center(
                                        child: Text(widget.shoppingCart
                                            .getProductsList()[index - 1]
                                            .name),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFE5E6EA),
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      margin: EdgeInsets.all(8.0),
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Center(
                                        child: Text(widget.shoppingCart
                                            .getProductsList()[index - 1]
                                            .quantity
                                            .toString()),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFE5E6EA),
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      margin: EdgeInsets.all(8.0),
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Center(
                                        child: Text((widget.shoppingCart
                                                    .getProductsList()[
                                                        index - 1]
                                                    .price *
                                                widget.shoppingCart
                                                    .getProductsList()[
                                                        index - 1]
                                                    .quantity)
                                            .toString()),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFE5E6EA),
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      margin: EdgeInsets.all(8.0),
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ],
                    );
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            //added by numan
            Flexible(
              child: GestureDetector(
                onTap: () async {
                  await _launchInWebViewWithJavaScript(
                      'https://sso.auth-sandbox.api.edenred.com/idsrv/connect/authorize?response_type=code&client_id=6e0dbfc6dd534faf8c54f8bc7a13b0d7&scope=openid%20edg-xp-mealdelivery-api&redirect_uri=http://nowhere.edenred.net/oauth/callback&state=abc123&nonce=456azerty&acr_values=tenant:it-ben&ui_locales=it-IT');
                },
                child: Container(
                  child: Image.asset('assets/url.jpg'),
                ),
              ),
            ),
            Text(
              'O paga con',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.07,
              child: RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Color(0xFFE5E6EA),
                child: couponApplied == LOADING
                    ? CircularProgressIndicator()
                    : couponApplied == FOUND
                        ? Text("Cedola applicata")
                        : Text("Applica coupon"),
                disabledColor: Color(0xFFE5E6EA),
                disabledTextColor: Colors.black,
                onPressed: _showDialog,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.07,
              child: RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Color(0xFFE5E6EA),
                child: cardAvailable == LOADING
                    ? CircularProgressIndicator()
                    : cardAvailable == FOUND
                        ? Text("Pagamento con carta **** $last4")
                        : Text("Aggiungi carta"),
                disabledColor: Color(0xFFE5E6EA),
                disabledTextColor: Colors.black,
                onPressed: cardAvailable == NOT_FOUND
                    ? () {
                        if (cardAvailable == NOT_FOUND) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CardCreate()));
                        }
                      }
                    : null,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.07,
              child: RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Conferma Pagamento',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                        discount == null
                            ? '€${widget.shoppingCart.getPrice()}'
                            : discount.data['type'] == "Percent"
                                ? "${(int.parse(discount.data['valueoff']) / 100) * widget.shoppingCart.getPrice()}€"
                                : "${widget.shoppingCart.getPrice() - int.parse(discount.data['valueoff'])}€",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                onPressed: cardAvailable == FOUND
                    ? () async {
                        setState(() {
                          cardAvailable = LOADING;
                        });
                        await Database.getInstance()
                            .addOrder(widget.shoppingCart, discount);
                        Database.getInstance()
                            .listenForPaymentConfirmation()
                            .listen((snap) {
                          if (snap == null || !snap.exists) return;
                          if (snap.data['status'] != null &&
                              snap.data['status']
                                      .toString()
                                      .compareTo('succeeded') ==
                                  0) {
                            ToastCall.showToast(
                                "Your Order Has Been Successfully Placed",
                                isLong: true);
                            Database.getInstance().clearOrderStatus();
                            widget.shoppingCart.clear();
                            Navigator.pop(context);
                          }
                        });
                      }
                    : null,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    couponCode.text = "";
    await showDialog<String>(
      context: context,
      builder: (context) => new AlertDialog(
        // contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'Codice'),
                controller: couponCode,
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Applicare'),
              onPressed: () async {
                setState(() {
                  couponApplied = LOADING;
                });
                discount = null;
                var doc = await Database.getInstance()
                    .listenForCouponConfirmation(couponCode.text);
                if (doc != null) {
                  if (doc.data['email'] == "" || email == doc.data['email']) {
                    setState(() {
                      discount = doc;
                      couponApplied = FOUND;
                    });
                    Navigator.pop(context);
                  }
                }
                if (discount == null) {
                  ToastCall.showToast("Coupon is Invalid", isLong: true);
                  setState(() {
                    discount = null;
                    couponApplied = NOT_FOUND;
                  });
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }
}

class CardInputFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function(StripeCard) onSubmit;

  CardInputFields({Key key, this.formKey, this.onSubmit})
      : numberEditingController = TextEditingController();
  final TextEditingController numberEditingController;

  @override
  Widget build(BuildContext context) {
    var defaultLabelText = 'Card number';
    var defaultHintText = 'xxxx xxxx xxxx xxxx';
    var defaultErrorText = 'Invalid card number';

    var defaultDecoration = InputDecoration(
      border: OutlineInputBorder(),
      labelText: defaultLabelText,
      hintText: defaultHintText,
    );
    var maskFormatter = MaskTextInputFormatter(mask: '#### #### #### ####');
    return Form(
      key: key,
      child: Column(
        children: <Widget>[
          Container(
            child: TextFormField(
              inputFormatters: [maskFormatter],
//            autovalidate: true,
              onEditingComplete: () {
                print("onEditingComplete");
              },
              onSaved: (text) {
                print('Saved:$text');
              },
//                      validator: validator,
              onChanged: (txt) {
                print(txt);
              },
              controller: numberEditingController,
              decoration: defaultDecoration,
              keyboardType: TextInputType.number,
//            textInputAction: TextInputAction,
            ),
          ),
          RaisedButton(
            child: Text("Invia"),
            onPressed: () {
              print(numberEditingController.text);
//              key.validate()
            },
          )
        ],
      ),
    );
  }
}

class CardFromList extends StatelessWidget {
  static const Widget dotPadding = SizedBox(width: 30);
  static final Widget dot = Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Text(
        "•",
        textScaleFactor: 2,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ));

  final CardResults cardModel;

  const CardFromList({this.cardModel});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: cardModel.cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 8)
            ]),
        child: RotatedBox(
          quarterTurns: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardChip(),
                      CardLogo(cardModel.cardType),
                    ]),
                SizedBox(height: 40),
                Wrap(
                    children: List<Widget>.filled(
                  12,
                  dot,
                  growable: true,
                )
                      ..insert(
                          // now get the spaces
                          4,
                          dotPadding)
                      ..insert(9, dotPadding)
                      ..add(dotPadding)
                      ..add(Text(
                        cardModel.cardNumber.substring(12),
                        style: TextStyle(color: Colors.white),
                        textScaleFactor: 1.25,
                      ))),
                Text(cardModel.cardNumber.substring(12),
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cardModel.cardHolderName,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Valid\nthru",
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 0.5,
                            textAlign: TextAlign.end,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            '${cardModel.cardMonth}/${cardModel.cardYear.substring(2)}',
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.2,
                          )
                        ],
                      )
                    ]),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      );
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        // padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
