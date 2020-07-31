import 'package:flutter/material.dart';
import '../shared/text_styles.dart' as style;

class TitleAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  Size size;

  TitleAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: size,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.pop(context) ;
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                ),
              ),
              Expanded(
                child: Text(
                  this.title,
                  style: style.appBarTextTheme,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(90);
}
