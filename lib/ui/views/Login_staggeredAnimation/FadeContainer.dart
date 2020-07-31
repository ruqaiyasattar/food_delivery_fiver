import 'package:flutter/material.dart';
import 'dart:async';
import '../mainHome.dart';

class FadeBox extends StatefulWidget {
  final Color primaryColor ;
  FadeBox({this.primaryColor}) ;
  @override
  _FadeBoxState createState() => _FadeBoxState();
}

class _FadeBoxState extends State<FadeBox> with TickerProviderStateMixin {
  AnimationController _screenController;
  Animation<Color> fadeScreenAnimation;
  @override
  void initState() {

    _screenController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    fadeScreenAnimation = ColorTween(
      begin: widget.primaryColor,
      end: widget.primaryColor.withOpacity(0),
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Interval(0.0, 1.0,curve: Curves.easeOutQuart),
    ));
    _screenController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _screenController,
        builder: (context, child) {
          return MainHome();
        },
      ),
    );
  }
}
