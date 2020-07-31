import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import 'package:food_delivery_app/core/models/user.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:food_delivery_app/ui/views/shoppingCart.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import '../widgets/flip_card.dart';
import '../widgets/card_front.dart';
import '../widgets/card_back.dart';
import '../../core/helpers/card_colors.dart';
import '../../core/helpers/formatters.dart';
import '../../core/card_model.dart';
import '../../core/models/card_color_model.dart';
import '../widgets/titleAppBar.dart';

class CardCreate extends StatefulWidget {
  @override
  _CardCreate createState() => _CardCreate();
}

class _CardCreate extends State<CardCreate> {
  final GlobalKey<FlipCardState> animatedStateKey = GlobalKey<FlipCardState>();

  FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  Future<Null> _focusNodeListener() async {
    animatedStateKey.currentState.toggleCard();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    CardModel cardModel = Provider.of<CardModel>(context);

    final _creditCard = Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        margin: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 0.0),
        child: FlipCard(
          key: animatedStateKey,
          front: CardFront(rotatedTurnsValue: 0),
          back: CardBack(),
        ),
      ),
    );

    final _cardHolderName = StreamBuilder(
        stream: cardModel.cardHolderName,
        builder: (context, snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.characters,
            onChanged: cardModel.changeCardHolderName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              hintText: 'Cardholder Name',
              errorText: snapshot.error,
            ),
          );
        });

    final _cardNumber = Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: StreamBuilder(
          stream: cardModel.cardNumber,
          builder: (context, snapshot) {
            return TextField(
              onChanged: cardModel.changeCardNumber,
              keyboardType: TextInputType.number,
              maxLength: 19,
              maxLengthEnforced: true,
              inputFormatters: [
                MaskedTextInputFormatter(
                  mask: 'xxxx xxxx xxxx xxxx',
                  separator: ' ',
                ),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                hintText: 'Card Number',
                counterText: '',
                errorText: snapshot.error,
              ),
            );
          }),
    );

    final _cardMonth = StreamBuilder(
      stream: cardModel.cardMonth,
      builder: (context, snapshot) {
        return Container(
          width: 50.0,
          child: TextField(
            onChanged: cardModel.changeCardMonth,
            keyboardType: TextInputType.number,
            maxLength: 2,
            maxLengthEnforced: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              hintText: 'MM',
              counterText: '',
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );

    final _cardYear = StreamBuilder(
        stream: cardModel.cardYear,
        builder: (context, snapshot) {
          return Container(
            width: 60.0,
            child: TextField(
              onChanged: cardModel.changeCardYear,
              keyboardType: TextInputType.number,
              maxLength: 4,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                hintText: 'YYYY',
                counterText: '',
                errorText: snapshot.error,
              ),
            ),
          );
        });

    final _cardVerificationValue = StreamBuilder(
        stream: cardModel.cardCvv,
        builder: (context, snapshot) {
          return Container(
            width: 70.0,
            child: TextField(
              focusNode: _focusNode,
              onChanged: cardModel.changeCardCvv,
              keyboardType: TextInputType.number,
              maxLength: 3,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  counterText: '',
                  hintText: 'CVV',
                  errorText: snapshot.error),
            ),
          );
        });

    final _saveCard = StreamBuilder(
      stream: cardModel.savecardValid,
      builder: (context, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width - 40,
          height: 50,
          child: RaisedButton(
              child: isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      'Add Card Payment',
                      style: TextStyle(color: Colors.white),
                    ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                var cardResult = cardModel.saveCard();
                print('CardNumber:${cardModel.saveCard().cardNumber}');
                Stripe.init("pk_live_1KvYzTvYkGhOQuEfcLR4EF1w0056Hev0tF");
                StripePayment.setOptions(StripeOptions(
                    publishableKey:
                        "pk_live_1KvYzTvYkGhOQuEfcLR4EF1w0056Hev0tF"));
                final CreditCard card = CreditCard(
                  number: cardResult.cardNumber,
                  expMonth: int.parse(cardResult.cardMonth),
                  expYear: int.parse(cardResult.cardYear),
                  cvc: cardResult.cardCvv,
                );
                print(card.number);
                StripePayment.createTokenWithCard(card).then((token) async {
                  print(token.toJson().toString());
                  String uid = (await Auth().currentUser()).uid;
                  var db = Database.getInstance(uid: uid);
                  await db.setCardToken(token.toJson());
                  db.listenForSources().listen((data) {
                    for (DocumentSnapshot d in data.documents) {
                      print("source:${d.data.toString()}");
                    }
                    if (data.documents.length == 0)
                      return;
                    else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShoppingCartView()));
                    }
                  });
                  db.listenForErrors().listen((snaps) {
                    for (DocumentSnapshot d in snaps.documents) {
                      if (d.data['tokenId'] != null &&
                          ((d.data['tokenId'].toString())
                                  .compareTo(token.toJson()['tokenId']) ==
                              0)) {
                        if (d.data['error'] != null) {
                          ToastCall.showToast(d.data['error'].toString());
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    }
                  });
                }).catchError((err) {
                  setState(() {
                    isLoading = false;
                  });
                  ToastCall.showToast(err.toString());
                });
              }
//            snapshot.hasData
//                ? () {
//                    Navigator.pushReplacementNamed(
//                        context,
//                        '/cardWallet');
//                  }
//                : null,
              ),
        );
      },
    );

    return new Scaffold(
        appBar: TitleAppBar(title: "Create card"),
        //backgroundColor: Colors.grey[100],
        body: ListView(
          itemExtent: 750.0,
          padding: EdgeInsets.only(top: 30.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: _creditCard,
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _cardHolderName,
                        _cardNumber,
                        SizedBox(height: 12.0),
                        Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 10,
                          children: <Widget>[
                            _cardMonth,
                            SizedBox(width: 26.0),
                            _cardYear,
                            SizedBox(width: 20.0),
                            _cardVerificationValue,
                          ],
                        ),
//                        SizedBox(height: 30.0),
                        cardColors(cardModel),
                        SizedBox(height: 50.0),
                        _saveCard,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget cardColors(CardModel cardModel) {
    final dotSize =
        (MediaQuery.of(context).size.width - 220) / CardColor.baseColors.length;

    List<Widget> dotList = new List<Widget>();

    for (var i = 0; i < CardColor.baseColors.length; i++) {
      dotList.add(
        StreamBuilder<List<CardColorModel>>(
          stream: cardModel.cardColorsList,
          builder: (context, snapshot) {
            cardModel.selectCardColor(0);
            return Container();
//            return Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10.0),
//              child: GestureDetector(
//                onTap: () => cardModel.selectCardColor(i),
//                child: Container(
//                  child: snapshot.hasData
//                      ? snapshot.data[i].isSelected
//                          ? Icon(
//                              Icons.check,
//                              color: Colors.white,
//                              size: 16.0,
//                            )
//                          : Container()
//                      : Container(),
//                  width: dotSize,
//                  height: dotSize,
//                  decoration: new BoxDecoration(
//                    color: CardColor.baseColors[i],
//                    shape: BoxShape.circle,
//                  ),
//                ),
//              ),
//            );
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: dotList,
    );
  }
}
