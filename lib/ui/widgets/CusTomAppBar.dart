import 'package:flutter/material.dart';
import '../shared/text_styles.dart' as style;


class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/shoppingCart');
                  },
                  child: Icon(Icons.shopping_cart, size: 32)),
              Expanded(
                child: Text(
                  "Bibi Mando",
                  style: style.appBarTextTheme,
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/notification') ;
                },
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ), preferredSize: null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(90);
}
