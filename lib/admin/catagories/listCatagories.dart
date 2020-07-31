import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/catagories/addCatagories.dart';
import 'package:food_delivery_app/core/database/database.dart';

class ListCatagory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'List of Catagory';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddCatagory()),
            );
          },
          icon: Icon(Icons.category),
          label: Text("Add category"),
          backgroundColor: Colors.redAccent,
        ),
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
      stream: Database.listCategories(),
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
                    return Padding(
                      padding: EdgeInsets.fromLTRB(3.0, 0, 3, 0),
                      child: Card(
                        margin: EdgeInsets.all(3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        elevation: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                width: 280,
                                child: Text(
                                    snapshot.data.documents[index].data["name"]),
                              ),
                            ),
                            InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text("Dell"),
                              ),
                              onTap: () async {
                                // String imageFileUrl =
                                //     "categories/"+snapshot.data.documents[index].data["imgUrl"];
                                // StorageReference fileUrl = await FirebaseStorage
                                //     .instance
                                //     .getReferenceFromUrl(imageFileUrl);
                                // fileUrl.delete();
                                Firestore.instance
                                    .collection("categories")
                                    .document(snapshot
                                        .data.documents[index].documentID)
                                    .delete();
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
