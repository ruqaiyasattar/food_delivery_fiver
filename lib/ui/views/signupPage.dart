//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/user.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:provider/provider.dart';
import '../shared/theme.dart';
import 'mainHome.dart';

class SignUpPage extends StatefulWidget {
  final Function goToSignIn;

  const SignUpPage({Key key, this.goToSignIn}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var loading=false;
  Auth authService=Auth();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController societyController=TextEditingController();
  TextEditingController vatController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController codiceController=TextEditingController();


  void enableLoading(){
    setState(() {
      loading=true;
    });
  }

  void disableLoading(){
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        alignment: Alignment.center,
        children: <Widget>[
          ListView(
            children: <Widget>[
              //Padding and logo
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: MediaQuery.of(context).size.height > 600
                        ? MediaQuery.of(context).size.height * 0.1
                        : MediaQuery.of(context).size.height * 0.05),
                child: Center(
                  child: Image.asset(
                    "assets/icons&splashs/launcher.png",
                    color: Theme.of(context).primaryColor,
                    height: 125,
                    width: 125,
                  ),
                ),
              ),
              //Title Name
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "NOME",
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
              //Padding and textfield
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                        controller: nameController,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Jon Doe',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //Email
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //Password
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //Confirm Password
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "CONFERMA PASSWORD",
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                        controller: confirmPasswordController,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //Society
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "SOCIETA’",
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                        controller: societyController,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'society',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //VAT
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "P.IVA",
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                        controller: vatController,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '123456',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //Address
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "INDIRIZZO",
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                        controller: addressController,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'xy street',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //Codice Univico
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "CODICE UNIVOCO",
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                        controller: codiceController,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '123456',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              //already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: FlatButton(
                      child: Text(
                        "HAI GIA’ UN ACCOUNT?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: widget.goToSignIn,
                    ),
                  ),
                ],
              ),
              //sign up button
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: 75
                ),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {

                          FieldSet fs=FieldSet(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                            societyController.text,
                            vatController.text,
                            addressController.text,
                            codiceController.text
                          );
                          performSignUp(fs);
//                        Navigator.pushNamed(context, '/phoneNumberRegister') ;
                        }
                        ,
                        child: Container(
//                      margin: EdgeInsets.only(bottom: 100),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "ISCRIVITI",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading?Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black12,
            child: Center(child: CircularProgressIndicator()),
          ):Container(),
        ],
      ),
    );
  }


  void performSignUp(FieldSet fs) {

    if(!fs.isValid())return;
    enableLoading();
    print("name:${fs.name} | email:${fs.email} | password:${fs.password}");
    try {
      authService.createUserWithEmailAndPassword(fs.email, fs.password,fs.name).then((uid){
        ToastCall.showToast("Sign Up Successful,Verify Email!");
        disableLoading();
        Database.writeUserDetails(fs.toMap(), uid:uid).then((documentReference){
          widget.goToSignIn();
        }).catchError((e){
          ToastCall.showToast(e.toString());
        });
      }).catchError((er){
        var msg="An Invalid Error Has Occured";
        if(er is AuthException)
          msg=er.message;
        else if(er is PlatformException)
          msg=er.message;
        ToastCall.showToast(msg);
        disableLoading();
        print(er);
      });
    } on Exception catch(er){
      var msg="An Invalid Error Has Occured";
      if(er is AuthException)
        msg=er.message;
      else if(er is PlatformException)
        msg=er.message;
      ToastCall.showToast(er.toString());
      print(er);
    }
  }

}
//
//Widget _commodityEntry() {
//  return Row(
//    children: <Widget>[
//      Expanded(
//        child: BlocBuilder<SiteOrdersBloC, SiteOrdersBloCState>(builder: (context, state) {
//          return Container(
//            child: MomTextFormField(
//              controller: _quantity,
//              validator: (value) => _bloC.quantityValidator,
//              autovalidate: _bloC.autoValidate,
//              decoration: InputDecoration(
//                icon: Icon(
//                  Icons.shopping_cart,
//                  color: Theme.of(context).iconTheme.color,
//                ),
//                labelText: _bloC.quantityLabel,
//              ),
//              focusNode: _quantityNode,
//              keyboardType: TextInputType.number,
//            ),
//          );
//        }),
//      ),
//      Expanded(
//        child: BlocBuilder<SiteOrdersBloC, SiteOrdersBloCState>(
//            bloc: _bloC,
//            builder: (context, state) {
//              return Container(
//                child: formModelFilterWidget(
//                  context,
//                  _bloC.onUnitSelected,
//                  _bloC.units,
//                  _bloC.selectedUnit,
//                  null,
//                  Strings.unit.terminologize,
//                  _bloC.autoValidate,
//                  _bloC.unitValidator,
//                ),
//              );
//            }),
//      ),
//      Expanded(
//        child: BlocBuilder<SiteOrdersBloC, SiteOrdersBloCState>(
//            bloc: _bloC,
//            builder: (context, state) {
//              return Container(
//                child: formModelFilterWidget(
//                  context,
//                  _bloC.onCommoditySelected,
//                  _bloC.commodities,
//                  _bloC.selectedCommodity,
//                  null,
//                  Strings.commodity.terminologize,
//                  _bloC.autoValidate,
//                  _bloC.commodityValidator,
//                ),
//              );
//            }),
//      ),
//    ],
//  );
//}

class FieldSet{
  String name;
  String email;
  String password;
  String confirmPassword;
  String society;
  String vat;
  String address;
  String codice;

  FieldSet(
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
    this.society,
    this.vat,
    this.address,
    this.codice,);

  bool isValid(){
    if(name.isEmpty){
      showToast("Name is Empty");
      return false;
    }
    if(email.isEmpty){
      showToast("Email is Empty");
      return false;
    }
    if(password.isEmpty){
      showToast("Password is Empty");
      return false;
    }
    if(confirmPassword.isEmpty){
      showToast("Confirm Password is Empty");
      return false;
    }
    // if(society.isEmpty){
    //   showToast("Society is Empty");
    //   return false;
    // }
    // if(vat.isEmpty){
    //   showToast("VAT is Empty");
    //   return false;
    // }
    if(address.isEmpty){
      showToast("Address is Empty");
      return false;
    }
    // if(codice.isEmpty){
    //   showToast("Codice Univico is Empty");
    //   return false;
    // }
    if(confirmPassword.compareTo(password)!=0){
      showToast("Password does not Match");
      return false;
    }
    return true;
  }

  void showToast(String msg){
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

  Map<String,String> toMap(){
    return {
      'name':name,
      'email':email,
      'society':society,
      'vat':vat,
      'address':address,
      'codice':codice,
    };
  }

  UserModel getUserModel(){
    UserModel userModel=UserModel();
    userModel.name=name;
    userModel.email=email;
    userModel.society=society;
    userModel.vat=vat;
    userModel.address=address;
    userModel.codice=codice;
    return userModel;
  }
}