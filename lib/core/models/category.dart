import 'package:cloud_firestore/cloud_firestore.dart';

class Category{
  String id;
  String name;
  String img;

  Category from(DocumentSnapshot doc) {
    this.id=doc.documentID;
    this.name=doc.data["name"];
    this.img=doc.data['imgUrl'];
    return this;
  }
}