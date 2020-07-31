import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './intro/Models/page_view_model.dart';
import './intro/intro_views_flutter.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    final size = MediaQuery.of(context).size;
    final pages = [
      PageViewModel(
        pageColor: background,
        iconImageAssetPath: 'assets/Walkthrough/transparent.png',
        iconColor: null,
        bubbleBackgroundColor: Colors.grey,
        body: Text(
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        ),
        title: Text(
          'Best Dishes',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        mainImage: Image.asset(
          Theme.of(context).brightness == Brightness.light
              ? 'assets/Walkthrough/Best_Chef_day.png'
              : 'assets/Walkthrough/Best_Chef_night.png',
          height: size.height * 0.5,
          width: size.width * 0.9,
          alignment: Alignment.center,
        ),
      ),
      PageViewModel(
        pageColor: background,
        iconImageAssetPath: 'assets/Walkthrough/transparent.png',
        iconColor: null,
        bubbleBackgroundColor: Colors.grey,
        body: Text(
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        ),
        title: Text(
          'Cheap Price',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        mainImage: Image.asset(
          Theme.of(context).brightness == Brightness.light
              ? 'assets/Walkthrough/Perfect_Price_day.png'
              : 'assets/Walkthrough/Perfect_Price_night.png',
          height: size.height * 0.5,
          width: size.width * 0.9,
          alignment: Alignment.center,
        ),
      ),
      PageViewModel(
        pageColor: background,
        iconImageAssetPath: 'assets/Walkthrough/transparent.png',
        iconColor: null,
        bubbleBackgroundColor: Colors.grey,
        body: Text(
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        ),
        title: Text(
          'Perfect Serving',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        mainImage: Image.asset(
          Theme.of(context).brightness == Brightness.light
              ? 'assets/Walkthrough/Perfect_Taste_day.png'
              : 'assets/Walkthrough/Perfect_Taste_night.png',
          height: size.height * 0.5,
          width: size.width * 0.9,
          alignment: Alignment.center,
        ),
      ),
      PageViewModel(
        pageColor: background,
        iconImageAssetPath: 'assets/Walkthrough/transparent.png',
        iconColor: null,
        bubbleBackgroundColor: Colors.grey,
        body: Text(
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        ),
        title: Text(
          'Relaxed Atmosphere',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        mainImage: Image.asset(
          Theme.of(context).brightness == Brightness.light
              ? 'assets/Walkthrough/Relaxed_Atmosphere_day.png'
              : 'assets/Walkthrough/Relaxed_Atmosphere_night.png',
          height: size.height * 0.5,
          width: size.width * 0.9,
          alignment: Alignment.center,
        ),
      )
    ];

    return Scaffold(
      body: IntroViewsFlutter(
        pages,
        onTapDoneButton: () async{
          SharedPreferences preferences=await SharedPreferences.getInstance();
          await preferences.setBool("isBoardingDone", false);
          Navigator.pushReplacementNamed(context, '/');
        },
        showSkipButton: true,
        pageButtonTextStyles: TextStyle(
            fontSize: 18.0,
            fontFamily: "Regular",
            color: Theme.of(context).primaryColor),
      ),
    );
  }
}
