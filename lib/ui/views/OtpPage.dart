import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';

import 'Login_staggeredAnimation/FadeContainer.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({Key key, this.phoneNumber}) : super(key: key);


  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {

  Auth authService=Auth();
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();

  TextEditingController currController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  @override
  void initState() {
    super.initState();
    authService.addPhoneNumber(context, widget.phoneNumber, _verificationComplete, _verificationFailed);
    currController = controller1;
  }

  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    print("_verificationComplete${authCredential.toString()}");
    authService.currentUser().then((user){
      user.linkWithCredential(authCredential).then((result){
        Database
            .writeUserDetails({'phoneNumber':result.user.phoneNumber},uid:result.user.uid)
            .then((val){
          ToastCall.showToast("Phone Added Successfully");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FadeBox(
                primaryColor: Theme.of(context).primaryColor,
              ),
            ),
          );
        });
      });
    });
  }


  _verificationFailed(AuthException authException, BuildContext context) {
    print("verificationFailed:${authException.message.toString()}");
    final snackBar = SnackBar(content: Text("Exception!! message:" + authException.message.toString()));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ?Color.fromRGBO(0, 0, 0, 0.1):Colors.grey,
                border:
                    Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                borderRadius: BorderRadius.circular(4.0)),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ?Color.fromRGBO(0, 0, 0, 0.1):Colors.grey,
              border:
                  Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ?Color.fromRGBO(0, 0, 0, 0.1):Colors.grey,
              border:
                  Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ?Color.fromRGBO(0, 0, 0, 0.1):Colors.grey,
              border:
                  Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0,),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ?Color.fromRGBO(0, 0, 0, 0.1):Colors.grey,
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller5,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ?Color.fromRGBO(0, 0, 0, 0.1):Colors.grey,
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller6,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0,),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Verifying your number!",
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 4.0, right: 16.0),
                  child: Text(
                    "Please type the verification code sent to",
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 2.0, right: 30.0),
                  child: Text(
                    widget.phoneNumber,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image(
                    image: AssetImage('assets/otp2.png'),
                    height: 120.0,
                    width: 120.0,
                  ),
                )
              ],
            ),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GridView.count(
                          crossAxisCount: 8,
                          mainAxisSpacing: 10.0,
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          children: List<Container>.generate(
                              8,
                                  (int index) =>
                                  Container(child: widgetList[index]))),
                    ]),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 16.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("1");
                              },
                              child: Text("1",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("2");
                              },
                              child: Text("2",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("3");
                              },
                              child: Text("3",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("4");
                              },
                              child: Text("4",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("5");
                              },
                              child: Text("5",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("6");
                              },
                              child: Text("6",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("7");
                              },
                              child: Text("7",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("8");
                              },
                              child: Text("8",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("9");
                              },
                              child: Text("9",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () {
                                  deleteText();
                                },
                                child: Image.asset('assets/delete.png',
                                    width: 25.0, height: 25.0,color: Theme.of(context).textSelectionColor,)),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField("0");
                              },
                              child: Text("0",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                                onPressed: () {
                                  matchOtp();
                                },
                                child: Icon(Icons.check_circle,size: 25,color: Theme.of(context).primaryColor,)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller5;
    }

    //Edit fifth textField
    else if (currController == controller5) {
      controller5.text = str;
      currController = controller6;
    }

    //Edit sixth textField
    else if (currController == controller6) {
      controller6.text = str;
      currController = controller6;
    }
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller5;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = "";
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = "";
      currController = controller5;
    }
  }

  void matchOtp() {
  String otpCode=controller1.text+controller2.text+controller3.text+controller4.text+controller5.text+controller6.text;
  print(otpCode);
  authService.signInWithCode(otpCode).then((result){
    Database
        .writeUserDetails({'phoneNumber':result.user.phoneNumber},uid:result.user.uid)
        .then((val){
          ToastCall.showToast("Phone Added Successfully");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FadeBox(
                primaryColor: Theme.of(context).primaryColor,
              ),
            ),
          );
        });
    });
  }
}
