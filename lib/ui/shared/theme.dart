import 'package:flutter/material.dart';
import 'dart:async';

enum switcherState { day_idle, night_idle ,switch_night,switch_day}

class ThemeChanger with ChangeNotifier {
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Color(0xff5563ff);
  static Color darkAccent = Color(0xff5563ff);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow[600];
  final ThemeData themeDark = ThemeData(
      backgroundColor: darkBG,
      brightness: Brightness.dark,
      primaryColor: Color(0xFFBB86FC),
      hintColor: Colors.white.withOpacity(0.7),
      accentColor: Color(0xFFBB86FC),
      scaffoldBackgroundColor: darkBG,
      cursorColor: darkAccent,
      textSelectionColor: Colors.white,
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(
            color: lightBG,
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ));
  final ThemeData themeLight = ThemeData(
      backgroundColor: lightBG,
      brightness: Brightness.light,
      primaryColor: Color(0xff810F3A),
      accentColor: Color(0xff810F3A),
      cursorColor: lightAccent,
      scaffoldBackgroundColor: lightBG,
      textSelectionColor: Colors.black,
      hintColor: Colors.grey,
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(
            color: darkBG,
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ));
  ThemeData _themeData;
  switcherState switcherAnim = switcherState.day_idle;
  ThemeChanger(){
    this._themeData = themeLight;
  }
  getSwitcherAnim() => this.switcherAnim ;

  toggleTheme() async{
    if (this._themeData == themeLight){
      this.switcherAnim = switcherState.switch_night ;
      notifyListeners() ;
      await Future.delayed(Duration(milliseconds: 300));
      this.switcherAnim = switcherState.night_idle ;
      this._themeData = themeDark;}
    else{
      this.switcherAnim = switcherState.switch_day ;
      notifyListeners() ;
      await Future.delayed(Duration(milliseconds: 300));
      this.switcherAnim = switcherState.day_idle ;
      this._themeData = themeLight;
    }
    notifyListeners();
  }

  getTheme() => _themeData;

}
