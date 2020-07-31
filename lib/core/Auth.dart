import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password,String name);
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    print("signInWithEmailAndPassword");
    final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    return user?.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(String email, String password,String name) async {
    final FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    UserUpdateInfo userInfo=UserUpdateInfo();
    userInfo.displayName=name;
    await user.updateProfile(userInfo);
    await user.sendEmailVerification();
    return user?.uid;
  }

  @override
  Future<FirebaseUser> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> signInWithGoogle() async{
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("Sign In With Google Successful");
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print("got google userAuth");
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user.uid;
  }

  // Future<String> singInWithFacebook()async{
  //   final FacebookLogin facebookLogin = FacebookLogin();
  //   facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   final FacebookLoginResult result =
  //   await facebookLogin.logIn(<String>['public_profile']);
  //   if (result.accessToken != null) {
  //     final AuthResult authResult = await _firebaseAuth.signInWithCredential(
  //       FacebookAuthProvider.getCredential(
  //           accessToken: result.accessToken.token),
  //     );
  //     return authResult.user.uid;
  //   } else {
  //     throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //   }
  // }

  Future<bool> isEmailVerified(){
    return _firebaseAuth.currentUser().then((user){
      if(user==null) return false;
      return user.isEmailVerified;
    });
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> isPhoneNumberAdded() {
    return _firebaseAuth.currentUser().then((user){
      print(user.phoneNumber);
      return user.phoneNumber!=null;
    });
  }


  Future<AuthResult> signInWithCode(String code){
    print("signInWithCode$code");
    AuthCredential authCredential=PhoneAuthProvider.getCredential(verificationId: _smsVerificationCode, smsCode: code);
    return _firebaseAuth.currentUser().then((user) {
      return user.linkWithCredential(authCredential).then((result) {
//        print("Success:${user.user.phoneNumber}");
        return result;
      }).catchError((e) {
        ToastCall.showToast("Failed:${e.toString()}");
        return null;
      });
    });
  }

  addPhoneNumber(BuildContext context,String phoneNumber,Function verificationComplete,Function verificationFailed) async {
    print("addPhoneNumber$phoneNumber");
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (authCredential) => verificationComplete(authCredential, context),
        verificationFailed: (authException) => verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) => _smsCodeSent(verificationId, [code]));
  }

  /// will get an AuthCredential object that will help with logging into Firebase.
//  _verificationComplete(AuthCredential authCredential, BuildContext context) {
//    FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult) {
//      final snackBar = SnackBar(content: Text("Success!!! UUID is: " + authResult.user.uid));
//      Scaffold.of(context).showSnackBar(snackBar);
//    });
//  }
  String _smsVerificationCode;
  String _smsVerificationId;
  _smsCodeSent(String verificationId, List<int> code) {
    print("_smsCodeSent$verificationId");
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
  }

//  _verificationFailed(AuthException authException, BuildContext context) {
//    final snackBar = SnackBar(content: Text("Exception!! message:" + authException.message.toString()));
//    Scaffold.of(context).showSnackBar(snackBar);
//  }

  _codeAutoRetrievalTimeout(String verificationId) {
    print("_codeAutoRetrievalTimeout");
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
  }

  void resetPassword(String email) {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

}

class PhoneAuthResult{

}