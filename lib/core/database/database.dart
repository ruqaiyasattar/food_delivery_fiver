import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/admin/main.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import 'package:food_delivery_app/core/models/category.dart';
import 'package:food_delivery_app/core/models/product.dart';

class Database {
  static Database _instance;
  String uid;
  Firestore db;

  Database(String uid) {
    db = Firestore.instance;
    this.uid = uid;
  }

  static Database getInstance({String uid}) {
    if (_instance == null) _instance = new Database(uid);

    return _instance;
  }

  static Future<void> writeToDocument(
      String path, Map<String, dynamic> map) async {
    await Firestore.instance.document(path).setData(map);
    return null;
  }

  static Future<void> writeUserDetails(Map<String, dynamic> user,
      {String uid}) async {
    if (uid == null) {
      FirebaseUser user = await Auth().currentUser();
      uid = user.uid;
    }
    await Firestore.instance
        .collection("users")
        .document(uid)
        .setData(user, merge: true);
    return null;
  }

  static Future<Map<String, dynamic>> readUserDetails() {
    return Auth().currentUser().then((user) {
      return Firestore.instance
          .collection("users")
          .document(user.uid)
          .get()
          .then((snap) {
        snap.data.addAll({'uid': user.uid});
        return snap.data;
      });
    });
  }

  static Stream<QuerySnapshot> listCategories() {
    return Firestore.instance.collection("categories").snapshots();
  }

  static Stream<QuerySnapshot> listproducts() {
    return Firestore.instance.collection("products").snapshots();
  }

  static setProducts(
      BuildContext context,
      String category,
      String categoryID,
      String description,
      Map extras,
      List<File> images,
      String name,
      double price,
      int quantity) async {
    Fluttertoast.showToast(
        msg: ' Upload Images ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    List<String> imagesUrl = new List<String>();
    for (File i in images) {
      FirebaseStorage storage = FirebaseStorage();
      String filePathCover =
          'products/${i.path.split('/').last}' + DateTime.now().toString();
      StorageUploadTask uploadTask =
          storage.ref().child(filePathCover).putFile(i);
      String dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      imagesUrl.add(dowurl);
    }
    await Firestore.instance.collection("products").document().setData({
      "category": category,
      "categoryID": categoryID,
      "description": description,
      "extras": extras,
      "images": imagesUrl,
      "name": name,
      "price": price,
      "quantity": quantity
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AdminPanal()));
  }

  static setCategories(BuildContext context, String name, File file) async {
    FirebaseStorage storage = FirebaseStorage();
    String filePathCover =
        'categories/${file.path.split('/').last}' + DateTime.now().toString();
    StorageUploadTask uploadTask =
        storage.ref().child(filePathCover).putFile(file);
    String dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    await Firestore.instance
        .collection("categories")
        .document()
        .setData({"name": name, "imgUrl": dowurl});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AdminPanal()));
  }

  Future<List<Category>> getCategories() {
    return db
        .collection("categories")
        .getDocuments(source: Source.serverAndCache)
        .then((val) {
      List<Category> categories = new List();
      for (var doc in val.documents) {
        categories.add(Category().from(doc));
      }
      return categories;
    });
  }

//  Future<List<Product>> getLatestMenuItems(){
//    return db.collection("products").getDocuments(source: Source.serverAndCache).then((val){
//      List<Product> products=new List();
////      Map<String,dynamic> map;
//      for(var doc in val.documents){
////        map=doc.data;
//        products.add(Product().from(doc));
//      }
////      for(int i=0;i<50;i++){
////        db.collection("products").document().setData(map);
////      }
//      return products;
//    });
//  }

  Future<void> setCardToken(Map<String, dynamic> token) async {
    await db
        .collection("stripe_customers")
        .document(uid)
        .collection("tokens")
        .document()
        .setData(token, merge: false);
    return;
  }

  void deleteProductWithId(String id) {
    db.collection('products').document(id).delete();
  }

  Future<List<DocumentSnapshot>> getAllProducts() async {
    print("getAllProducts");
    return db
        .collection("products")
        .getDocuments(source: Source.serverAndCache)
        .then((val) {
      return val.documents;
    });
  }

  void addChargeSource(double amount) {
    db
        .collection('stripe_customers/${uid}/charges')
        .document()
        .setData({'amount': amount});
  }

  Stream<QuerySnapshot> listenForSources() {
    return db
        .collection('stripe_customers')
        .document(uid)
        .collection("sources")
        .snapshots();
  }

  Stream<DocumentSnapshot> listenForPaymentConfirmation() {
    return db.collection('orders').document(uid).snapshots();
  }

  Future<DocumentSnapshot> listenForCouponConfirmation(String code) async {
    QuerySnapshot docs = await db.collection('coupons').where('code', isEqualTo: code).getDocuments();
    if(docs.documents.length > 0){
        var doc = docs.documents[0];
        var snap = await db.collection('orders').document(uid).get();
        if(snap.data['coupons'] != null && snap.data['coupons'].contains(doc.documentID)) return null;
        else return doc;
    }
    return null;
  }

  Future addOrder(ShoppingCart shoppingCart, DocumentSnapshot discount) async {
    List<String> productList = [];
    List<int> quantities = [];

    for (Product p in shoppingCart.getProductsList()) {
      productList.add(p.id);
      quantities.add(p.quantity);
    }

    Map<String, dynamic> shoppingDetails = {
      'productList': productList,
      'quantities': quantities,
      'status': "0",
      'discount' : discount == null?null:discount.documentID,
    };
    
    await db
        .collection('orders')
        .document(uid)
        .collection('requests')
        .document()
        .setData(shoppingDetails);
    return;
  }

  void clearOrderStatus() {
    db
        .collection('orders')
        .document(uid)
        .setData({'status': null}, merge: true);
  }

  Stream<QuerySnapshot> listenForErrors() {
    return db
        .collection('stripe_customers')
        .document(uid)
        .collection("tokens")
        .snapshots();
  }

  static Future<Map<String, Map>> getOrdersDetailsList() async {
    Map<String, Map> list = new Map<String, Map>();
    var val = await Firestore.instance
        .collection("orders")
        .getDocuments(source: Source.serverAndCache);
    for (var item in val.documents) {
      var userdetails = await Firestore.instance
          .collection("users")
          .document(item.documentID)
          .get(source: Source.serverAndCache);
      Map<String, Map> map2 = new Map<String, Map>();
      Map<String,dynamic> temp = new Map<String,dynamic>();
      temp = userdetails.data;
      temp["uId"] = item.documentID;
      map2["user"] = temp;
      var val2 = await Firestore.instance
          .collection("orders")
          .document(item.documentID)
          .collection("requests")
          .getDocuments(source: Source.serverAndCache);
      for (var item2 in val2.documents) {
        Map<String, Map> map = new Map<String, Map>();
        for (int i = 0; i < item2.data.length; i++) {
          Map<int, int> quality = new Map<int, int>();
          int count = 0;
          for (int kk in item2.data["quantities"]) {
            quality[count++] = kk;
          }
          count = 0;
          map["quantities"] = quality;
          Map<int, Map> productList = new Map<int, Map>();
          for (String prokey in item2.data["productList"]) {
            var prodetails = await Firestore.instance
                .collection("products")
                .document(prokey)
                .get();
            productList[count++] = prodetails.data;
          }
          map["productList"] = productList;
          map["status"] = {"status": item2.data["status"]};
        }
        map["orderId"] = {"oId": item2.documentID};
        map.addAll(map2);
        list[item2.documentID] = map;
        map = null;
      }
    }
    return list;
  }

  Future<List<DocumentSnapshot>> getSingleProduct(id) {
    return Firestore.instance
        .collection("products")
        .document(id)
        .collection("requests")
        .getDocuments(source: Source.serverAndCache)
        .then((val) {
      return val.documents;
    });
  }
}
