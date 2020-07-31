import '../../core/card_list_model.dart';
import '../views/PaymentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../core/models/card_model.dart';
import 'card_chip.dart';
import "card_logo.dart";
import 'package:provider/provider.dart';

class CardList extends StatelessWidget {
  int selectedcardindex = 0;

  @override
  Widget build(BuildContext context) {
    CardListModelView cardlistProvided =
        Provider.of<CardListModelView>(context);
    final _screenSize = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        StreamBuilder<List<CardResults>>(
          stream: cardlistProvided.cardList,
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? CircularProgressIndicator()
                : SizedBox(
                    height: _screenSize.height * 0.75,
                    child: Swiper(
                      onIndexChanged: (index) {
                        selectedcardindex = index;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return CardFromList(
                          cardModel: snapshot.data[index],
                        );
                      },
                      itemCount: snapshot.data.length,
                      itemWidth: _screenSize.width * 0.6,
                      itemHeight: _screenSize.height *
                          (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 0.52
                              : 0.6),
                      layout: SwiperLayout.STACK,
                      scrollDirection: Axis.vertical,
                    ),
                  );
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.07,
          child: RaisedButton(
            textColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.red,
            child: Text(
              'Select Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              cardlistProvided.selectCard(selectedcardindex);
              Navigator.pop(context);
            },
          ),
        )
      ],
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
            color: cardModel.cardColor),
        child: RotatedBox(
          quarterTurns:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 3
                  : 0,
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
              ],
            ),
          ),
        ),
      );
}
