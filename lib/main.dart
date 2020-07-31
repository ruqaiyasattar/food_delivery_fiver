import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import './ui/router.dart';

import 'core/card_list_model.dart';
import 'core/card_model.dart';
import 'locator.dart';
import 'package:provider/provider.dart';
import './ui/shared/theme.dart';

void main() {
  setupLocator() ;
  runApp(MyApp()) ;
}
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: MaterialAppWithTheme(),
    );
  }
}
class MaterialAppWithTheme extends StatefulWidget {
  @override
  _MaterialAppWithThemeState createState() => _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends State<MaterialAppWithTheme> {

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => locator<CardListModelView>()),
        ChangeNotifierProvider(create: (context) => locator<CardModel>()),
        ChangeNotifierProvider(create: (context) => ShoppingCart(),)
      ],
      child: MaterialApp(
        onGenerateRoute: Router.generateRoute,
        initialRoute: '/splashScreen',
        theme: theme.getTheme(),
        title: 'Restaurant Template',
      ),
    );
  }
}

