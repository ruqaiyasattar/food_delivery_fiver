import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/Ourproducts/catagorieslist.dart';
import 'package:food_delivery_app/admin/spec/addSpecial.dart';
import 'package:food_delivery_app/core/database/database.dart';

class MySpecialProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'List of Products';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.listproducts(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                height: 45,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
              );
            default:
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return snapshot.data.documents[index].data["name"] == null
                        ? SizedBox(height: 0)
                        : Padding(
                            padding: EdgeInsets.fromLTRB(3.0, 0, 3, 0),
                            child: Card(
                              margin: EdgeInsets.all(3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              elevation: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      width: 280,
                                      child: Text(snapshot.data.documents[index]
                                              .data["name"] ??
                                          ""),
                                    ),
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                    onTap: () async {
                                      Navigator.of(context).pushReplacement(
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              new AddSpecialProduct(
                                                  snapshot.data.documents[index]
                                                      .data["name"],
                                                  snapshot.data.documents[index]
                                                      .documentID),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                  },
                ),
              );
          }
        }
      },
    );
  }
}
