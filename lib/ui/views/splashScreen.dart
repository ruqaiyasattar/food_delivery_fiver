import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/main.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:food_delivery_app/ui/views/mainHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_home_wrapper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Auth authService = Auth();
  
    authService.currentUser().then((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        if (user.email == "fooddeliveryapp28@gmail.com") {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => new AdminPanal(),
            ),
          );
        } else
          authService.isEmailVerified().then((isVerified) async {
            if (isVerified) {
              Database.getInstance(uid: user.uid);
              ProductList productList = await ProductList().getProductsList();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainHomeWrapper(
                    productList: productList,
                  ),
                ),
              );
            } else {
              authService.signOut();
              ToastCall.showToast("Email not Verified");
              Navigator.pushReplacementNamed(context, '/');
            }
          });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    navigationPage();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset(
              "assets/icons&splashs/launcher.png",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
