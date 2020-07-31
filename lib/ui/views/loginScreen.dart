import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/admin/main.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:food_delivery_app/ui/views/Login_staggeredAnimation/staggeredAnimation.dart';
import '../shared/custom_social_icons.dart';
import 'main_home_wrapper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  var loading = false;
  Auth authService = Auth();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signInWithGoogle() {
    enableLoading();
    authService.signInWithGoogle().then((uid) async {
      if (uid == null) return;
      ProductList productList = await ProductList().getProductsList();
      disableLoading();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomeWrapper(
            productList: productList,
          ),
        ),
      );
    }).catchError((err) {
      disableLoading();
      ToastCall.showToast(err.message);
    });
  }

  // void signInWithFacebook() {
  //   enableLoading();
  //   authService.singInWithFacebook().then((uid) async {
  //     if (uid == null) return;
  //     ProductList productList = await ProductList().getProductsList();
  //     disableLoading();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => MainHomeWrapper(
  //           productList: productList,
  //         ),
  //       ),
  //     );
  //   }).catchError((err) {
  //     disableLoading();
  //     print(err);
  //   });
  // }

  bool validInput(String email, String password) {
    if (email.isEmpty) {
      ToastCall.showToast("Email is Empty");
      return false;
    }
    if (password.isEmpty) {
      ToastCall.showToast("Email is Empty");
      return false;
    }
    if (password.length < 6) {
      ToastCall.showToast("Password length is too Short");
      return false;
    }
    return true;
  }

  void resetPassword(String email) {
    if (email.isEmpty) {
      ToastCall.showToast("Email is empty");
      return;
    }
    try {
      authService.resetPassword(email);
      ToastCall.showToast("Email sent to reset Password");
    } on Exception catch (_) {
      ToastCall.showToast("Failed To Reset Password");
    }
  }

  void enableLoading() {
    setState(() {
      loading = true;
    });
  }

  void disableLoading() {
    setState(() {
      loading = false;
    });
  }

  void performLogin(String email, String password) async {
    print("Email$email, Password$password");
    enableLoading();
    if (!validInput(email, password)) {
      disableLoading();
      return;
    }
    try {
      authService.signInWithEmailAndPassword(email, password).then((uid) {
        print(uid);
        if (uid == null) {
          disableLoading();
          return;
        }
        if (email == "fooddeliveryapp28@gmail.com")
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPanal(),
            ),
          );
        else
          authService.isEmailVerified().then((isVerified) async {
            print("isVerified$isVerified");
            if (isVerified) {
              Database.getInstance(uid: uid);
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
              disableLoading();
              ToastCall.showToast("Email Not Verified");
              authService.signOut();
            }
          });
      }).catchError((err) {
        var msg = "An Invalid Error Has Occured";
        if (err is AuthException || err is PlatformException) msg = err.message;
        disableLoading();
        Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } on Exception catch (ex) {
      disableLoading();
      var msg = "An Invalid Error Occured";
      if (ex is PlatformException) {
        msg = ex.message;
      } else if (ex is AuthException) {
        msg = ex.message;
      }

      print(ex);
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.05), BlendMode.dstATop),
                image: AssetImage('assets/home_background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
//              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: MediaQuery.of(context).size.height > 600
                              ? MediaQuery.of(context).size.height * 0.1
                              : MediaQuery.of(context).size.height * 0.05),
                      child: Center(
                        child: Image.asset(
                          "assets/Asset51.png",
                          color: Theme.of(context).primaryColor,
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              "EMAIL",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: emailController,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'restaurantapp@live.com',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              "PASSWORD",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '*********',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: FlatButton(
                            child: Text(
                              "RECUPERA PASSWORD?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            onPressed: () {
                              resetPassword(emailController.text);
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                animationStatus == 0
                    ? Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.98 -
                                180),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                        //alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                performLogin(emailController.text,
                                    passwordController.text);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "LOGIN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    : StaggerAnimation(
                        buttonController: _loginButtonController.view,
                        screenSize: MediaQuery.of(context).size,
                      ),
                loading
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black12,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
