import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/core/models/user.dart';
import 'package:provider/provider.dart';
import '../widgets/CusTomAppBar.dart';
import 'LandingPage.dart';
import './searchScreen.dart';
import './ProfilePage.dart';
import 'favoritePage.dart';

class MainHome extends StatefulWidget {
  final ProductList productList;

  const MainHome({Key key, this.productList}) : super(key: key);
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  Color primaryColor;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
  }

  Widget currentPage(position) {
    if (position == 0){
      return LandingPage();
    }
    if( position == 1) {
      return Center(
          child: SearchPanel()
      );
    }
    if (position == 2){
      return FavoriteList() ;
    }
    if(position == 3 ){
      return ProfilePage() ;
    }
    return LandingPage();
  }

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      bottomNavigationBar: FancyBottomNavigation(
        textColor: Theme.of(context).hintColor,
        activeIconColor: Colors.white,
        circleColor: primaryColor,
        inactiveIconColor: primaryColor,
        initialSelection: 0,
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.search, title: "Search"),
          TabData(iconData: Icons.favorite, title: "Preferiti"),
          TabData(iconData: Icons.person, title: "Profilo"),
        ],
        onTabChangedListener: (position) {
          setState(() {
            currentPageIndex = position;
          });
        },
      ),
      body:currentPage(currentPageIndex),
      appBar: CustomAppBar(),
    );
  }
}
