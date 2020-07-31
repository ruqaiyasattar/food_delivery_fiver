import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/admin/main.dart';
import 'package:food_delivery_app/core/database/database.dart';

class AddSpecialProduct extends StatelessWidget {
  final String data, documentID;
  AddSpecialProduct(this.data, this.documentID);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Edit Product';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(appTitle),
        ),
        body: MyCustomForm(data, documentID),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final String data, documentID;
  MyCustomForm(this.data, this.documentID);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  GlobalKey<FormBuilderState> _fbKey;
  List<File> files;
  @override
  void initState() {
    super.initState();
    _fbKey = GlobalKey<FormBuilderState>();
    files = new List<File>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {},
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  FormBuilderSwitch(
                    label: Text('Mark the product as latest products'),
                    attribute: "lp",
                    initialValue: false,
                  ),
                  FormBuilderSwitch(
                    label: Text('Mark the product as popular products'),
                    attribute: "pp",
                    initialValue: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            MaterialButton(
              color: Colors.redAccent,
              child: Text("Update", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_fbKey.currentState.saveAndValidate()) {
                  Fluttertoast.showToast(
                      msg: ' Please Wait ',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  bool lp = _fbKey.currentState.value['lp'];
                  bool pp = _fbKey.currentState.value['pp'];
                  if (lp) {
                    await Firestore.instance
                        .collection('products')
                        .document('latest_products')
                        .updateData({
                      'products': FieldValue.arrayUnion([widget.documentID])
                    });
                  } else {
                    await Firestore.instance
                        .collection('products')
                        .document('latest_products')
                        .updateData({
                      'products': FieldValue.arrayRemove([widget.documentID])
                    });
                  }
                  if (pp) {
                    await Firestore.instance
                        .collection('products')
                        .document('popular_products')
                        .updateData({
                      'products': FieldValue.arrayUnion([widget.documentID])
                    });
                  } else {
                    await Firestore.instance
                        .collection('products')
                        .document('latest_products')
                        .updateData({
                      'products': FieldValue.arrayRemove([widget.documentID])
                    });
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPanal()),
                  );
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}
