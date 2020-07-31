import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import 'package:food_delivery_app/core/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:food_delivery_app/ui/shared/theme.dart';
import '../shared/text_styles.dart' as style;
import 'package:flare_flutter/flare_actor.dart';

enum C { name, email, address, society, vat, codice }

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const NAME = 0,
      EMAIL = 1,
      ADDRESS = 2,
      SOCIETY = 3,
      VAT = 4,
      CODICE = 5;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController addressController;
  TextEditingController societyController;
  TextEditingController vatController;
  TextEditingController codiceController;

  List<bool> isEdit = [false, false, false, false, false, false];
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    societyController = TextEditingController();
    vatController = TextEditingController();
    codiceController = TextEditingController();
    loadUserProfile();
  }

  void loadUserProfile() {
//    Provider.of<UserModel>(context).updateUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Consumer<ShoppingCart>(builder: (_, cart, __) {
      return Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    //background
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            color: Colors.transparent,
                            child: ClipPath(
                              clipper: BackClipper(),
                              child: Container(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //forground
                    Consumer<UserModel>(
                      builder: (context, user, child) {
                        nameController.text = user.name;
                        emailController.text = user.email;
                        addressController.text = user.address;
                        societyController.text = user.society;
                        vatController.text = user.vat;
                        codiceController.text = user.codice;
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: Container(
                                    height: 90.0,
                                    width: 90.0,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    child: GestureDetector(
                                      onTap: () async {
                                        File img = await ImagePicker.pickImage(
                                            source: ImageSource.gallery);
                                        StorageReference storageRef =
                                            FirebaseStorage.instance
                                                .ref()
                                                .child('avatars')
                                                .child('${user.uid}.jpg');
                                        storageRef
                                            .putFile(img)
                                            .onComplete
                                            .then((snap) async {
                                          String url =
                                              (await snap.ref.getDownloadURL())
                                                  .toString();
                                          FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          UserUpdateInfo info =
                                              UserUpdateInfo();
                                          info.photoUrl = url;
                                          (await auth.currentUser())
                                              .updateProfile(
                                            info,
                                          );
                                          setState(() {
                                            user.profileUrl = url;
                                          });
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: user.profileUrl == null
                                            ? AssetImage('assets/profile.png')
                                            : NetworkImage(
                                                user.profileUrl,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        theme.toggleTheme();
                                      },
                                      child: Container(
                                          width: 90.0,
                                          height: 45.0,
                                          child: FlareActor(
                                              "assets/switcher.flr",
                                              alignment: Alignment.center,
                                              animation: theme
                                                  .getSwitcherAnim()
                                                  .toString()
                                                  .substring(14))),
                                    ),
                                    Text(
                                      user.name ??= "N/A",
                                      style: style.headerStyle3
                                          .copyWith(color: Colors.white),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Auth authService = Auth();
                                        authService.signOut().then((val) {
                                          Navigator.pushReplacementNamed(
                                              context, '/');
                                        });
                                      },
                                      child: Container(
                                        width: 90.0,
                                        height: 45.0,
                                        child: Center(
                                          child: Icon(
                                            Icons.power_settings_new,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Email',
                                              style: style.headerStyle3
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              textAlign: TextAlign.center),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(user.email ??= "N/A", //
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 1.0,
                                      height: 40.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        children: <Widget>[
                                          Text('Telefono ',
                                              style: style.headerStyle3
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              textAlign: TextAlign.center),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            user.phoneNumber ??= "N/A",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              GridView.count(
                                crossAxisCount: 2,
                                primary: false,
                                crossAxisSpacing: 2.0,
                                mainAxisSpacing: 4.0,
                                shrinkWrap: true,
                                childAspectRatio: 2.0,
                                children: <Widget>[
                                  _buildCard('Punti Premio', '0',
                                      Icons.card_giftcard, 1),
                                  _buildCard(
                                      'Ordini in corso',
                                      cart.getProductsList().length.toString(),
                                      Icons.arrow_upward,
                                      2),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  //Name
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
//                                    height: MediaQuery.of(context).size.height * 0.08,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'NOME',
                                                style: style.headerStyle3,
                                              ),
                                              isEdit[NAME]
                                                  ? TextField(
                                                      controller:
                                                          nameController,
                                                      maxLines: 1,
                                                    )
                                                  : Text(
                                                      nameController.text ??=
                                                          "N/A",
                                                      style: style.subHintTitle,
                                                    )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (nameController.text !=
                                                  user.name) {
                                                isEdit[NAME] = !isEdit[NAME];
                                                Provider.of<UserModel>(context)
                                                    .setName(
                                                        nameController.text);
                                              } else {
                                                setState(() {
                                                  isEdit[NAME] = !isEdit[NAME];
                                                });
                                              }
                                            },
                                            child: Icon(isEdit[NAME]
                                                ? Icons.check
                                                : Icons.edit))
                                      ],
                                    ),
                                  ),
                                  //Email
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Email',
                                          style: style.headerStyle3,
                                        ),
                                        Text(
                                          user.email ??= "N/A",
                                          style: style.subHintTitle,
                                        )
                                      ],
                                    ),
                                  ),
                                  //Phone Number
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/phoneNumberRegister');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 8),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'teléfono',
                                                style: style.headerStyle3,
                                              ),
                                              Text(
                                                user.phoneNumber ??= "N/A",
                                                style: style.subHintTitle,
                                              )
                                            ],
                                          ),
                                          Icon(Icons.edit)
                                        ],
                                      ),
                                    ),
                                  ),
                                  //Address
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'INDIRIZZO',
                                                style: style.headerStyle3,
                                              ),
                                              isEdit[ADDRESS]
                                                  ? TextField(
                                                      controller:
                                                          addressController,
                                                      maxLines: 1,
                                                    )
                                                  : Text(
                                                      addressController.text ??=
                                                          "N/A",
                                                      style: style.subHintTitle,
                                                    )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (addressController.text !=
                                                  user.address) {
                                                isEdit[ADDRESS] =
                                                    !isEdit[ADDRESS];
                                                Provider.of<UserModel>(context)
                                                    .setAddress(
                                                        addressController.text);
                                              } else {
                                                setState(() {
                                                  isEdit[ADDRESS] =
                                                      !isEdit[ADDRESS];
                                                });
                                              }
                                            },
                                            child: Icon(isEdit[ADDRESS]
                                                ? Icons.check
                                                : Icons.edit))
                                      ],
                                    ),
                                  ),
                                  //Society
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "SOCIETA'",
                                                style: style.headerStyle3,
                                              ),
                                              isEdit[SOCIETY]
                                                  ? TextField(
                                                      controller:
                                                          societyController,
                                                      maxLines: 1,
                                                    )
                                                  : Text(
                                                      societyController.text ??=
                                                          "N/A",
                                                      style: style.subHintTitle,
                                                    )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (societyController.text !=
                                                  user.society) {
                                                isEdit[SOCIETY] =
                                                    !isEdit[SOCIETY];
                                                Provider.of<UserModel>(context)
                                                    .setSociety(
                                                        societyController.text);
                                              } else {
                                                setState(() {
                                                  isEdit[SOCIETY] =
                                                      !isEdit[SOCIETY];
                                                });
                                              }
                                            },
                                            child: Icon(isEdit[SOCIETY]
                                                ? Icons.check
                                                : Icons.edit))
                                      ],
                                    ),
                                  ),
                                  //VAT
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'P.IVA',
                                                style: style.headerStyle3,
                                              ),
                                              isEdit[VAT]
                                                  ? TextField(
                                                      controller: vatController,
                                                      maxLines: 1,
                                                    )
                                                  : Text(
                                                      vatController.text ??=
                                                          "N/A",
                                                      style: style.subHintTitle,
                                                    )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (vatController.text !=
                                                  user.vat) {
                                                isEdit[VAT] = !isEdit[VAT];
                                                Provider.of<UserModel>(context)
                                                    .setVAT(vatController.text);
                                              } else {
                                                setState(() {
                                                  isEdit[VAT] = !isEdit[VAT];
                                                });
                                              }
                                            },
                                            child: Icon(isEdit[VAT]
                                                ? Icons.check
                                                : Icons.edit))
                                      ],
                                    ),
                                  ),
                                  //Codice
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'CODICE UNIVOCO',
                                                style: style.headerStyle3,
                                              ),
                                              isEdit[CODICE]
                                                  ? TextField(
                                                      controller:
                                                          codiceController,
                                                      maxLines: 1,
                                                    )
                                                  : Text(
                                                      codiceController.text ??=
                                                          "N/A",
                                                      style: style.subHintTitle,
                                                    )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (codiceController.text !=
                                                  user.codice) {
                                                isEdit[CODICE] =
                                                    !isEdit[CODICE];
                                                Provider.of<UserModel>(context)
                                                    .setCodice(
                                                        codiceController.text);
                                              } else {
                                                setState(() {
                                                  isEdit[CODICE] =
                                                      !isEdit[CODICE];
                                                });
                                              }
                                            },
                                            child: Icon(isEdit[CODICE]
                                                ? Icons.check
                                                : Icons.edit))
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard(String title, String value, icon, int cardIndex) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1.0, blurRadius: 5.0, color: Colors.black38)
            ]),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.043,
                    ),
                  ),
                  Icon(icon)
                ],
              ),
            ),
            Expanded(
                child: Container(
                    width: 175.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Center(
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Theme.of(context).primaryColor),
                      ),
                    )))
          ],
        ),
        margin: cardIndex.isEven
            ? EdgeInsets.fromLTRB(10.0, 0.0, 25.0, 10.0)
            : EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0));
  }
}

class BackClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - size.height / 5);

    var firstControlPoint = new Offset(size.width / 2, size.height + 25);
    var firstEndPoint = new Offset(size.width, size.height - size.height / 5);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0.0);

    var secondControlPoint = new Offset(size.width / 2, size.height / 5 + 25);
    var secondEndPoint = new Offset(0.0, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
