import '../../core/card_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/card_list.dart';
import './card_type.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CardListModelView cardlistProvided =
        Provider.of<CardListModelView>(context);
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(onTap: (){
            Navigator.pop(context) ;
          },child: Icon(Icons.arrow_back_ios,color: Theme.of(context).textSelectionColor,)),
          automaticallyImplyLeading: true,
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            'Wallet',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
          ),

          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add,color: Theme.of(context).textSelectionColor,),
              onPressed: () {
                Navigator.pushNamed(context,
                   '/cardType');
              },
            )
          ],
        ),
        body: CardList());
  }
}
