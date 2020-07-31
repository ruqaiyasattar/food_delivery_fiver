import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastCall{
  static showToast(String msg,{bool isLong}){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: isLong==null?Toast.LENGTH_LONG:isLong?Toast.LENGTH_LONG:Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 2,
      backgroundColor: Color(0xff810F3A),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}