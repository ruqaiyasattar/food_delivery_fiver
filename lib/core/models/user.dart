import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';

class UserModel extends ChangeNotifier{

  String uid;
  String name;
  String email;
  String society;
  String vat;
  String address;
  String codice;
  String phoneNumber;
  String profileUrl;

  UserModel(){updateUser();}


  setName(String value) {
    Database.writeUserDetails({'name':value});
    name = value;
    notifyListeners();
  }
  setAddress(String value) {
    Database.writeUserDetails({'address':value});
    address = value;
    notifyListeners();
  }
  setVAT(String value) {
    Database.writeUserDetails({'vat':value});
    vat = value;
    notifyListeners();
  }
  setCodice(String value) {
    Database.writeUserDetails({'codice':value});
    codice = value;
    notifyListeners();
  }
  setSociety(String value) {
    Database.writeUserDetails({'society':value});
    society = value;
    notifyListeners();
  }
  setProfileUrl(String value) {
    Database.writeUserDetails({'profileUrl':value});
    profileUrl = value;
    notifyListeners();
  }

  void updateUser(){
    Database.readUserDetails().then((user){
      uid=user['uid'];
      name=user['name'];
      email=user['email'];
      society=user['society'];
      vat=user['vat'];
      address=user['address'];
      codice=user['codice'];
      phoneNumber=user['phoneNumber'];
//      profileUrl=user['profileUrl'];
      Auth().currentUser().then((user){
        this.profileUrl=user.photoUrl;
        this.phoneNumber=user.phoneNumber;
        notifyListeners();
      });
    });
  }

}