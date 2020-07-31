import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/ui/views/OtpPage.dart';
import 'package:food_delivery_app/ui/views/PhonenumberRegister.dart';
import 'package:food_delivery_app/ui/views/card_type.dart';
import 'package:food_delivery_app/ui/views/notificationPage.dart';
import 'package:food_delivery_app/ui/views/onBording.dart';
import './views/loginScreen.dart';
import './views/HomePage.dart';
import './views/mainHome.dart';
import './views/shoppingCart.dart';
import './views/splashScreen.dart';
import './views/ProfilePage.dart';
import './views/favoritePage.dart';
import './views/PaymentPage.dart';
import 'views/walletpage.dart';
import 'views/card_create.dart';
import 'views/card_wallet.dart';



const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      return MaterialPageRoute(builder: (_) => HomePage());
      case '/phoneNumberRegister':
        return MaterialPageRoute(builder: (_) => PhoneNumberRegister());
      case '/otpPage':
        return MaterialPageRoute(builder: (_) => OtpPage());
      case '/cardList':
        return MaterialPageRoute(builder: (_) => WalletPage());
      case '/cardCreate':
        return MaterialPageRoute(builder: (_) => CardCreate());
      case '/cardWallet':
        return MaterialPageRoute(builder: (_) => CardWallet());
      case '/cardType':
        return MaterialPageRoute(builder: (_) => CardType());
      case '/paymentPage':
        return MaterialPageRoute(builder: (_) => PaymentPage());
      case '/splashScreen':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/profilePage':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/favoritePage':
        return MaterialPageRoute(builder: (_) => FavoriteList());
      case '/mainHome':
        return MaterialPageRoute(builder: (_)=> MainHome());
      // case '/notification':
      //   return MaterialPageRoute(builder: (context) => NotificationPage()) ;
      case '/shoppingCart':
        return MaterialPageRoute(builder: (context) => ShoppingCartView());
      case '/onBoarding' :
        return MaterialPageRoute(builder: (context) => OnBoarding()) ;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}