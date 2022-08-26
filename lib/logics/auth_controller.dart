// ignore_for_file: use_build_context_synchronously
import 'package:emergencyalertresponder/layouts/alert_responder_to_verify.dart';

import '../layouts/home.dart';
import '../layouts/login.dart';
import '../layouts/toaster.dart';
import '../layouts/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
User? user;
String resultLoginUser = "Welcome";
String resultCreateUser = "success";
UserCredential? userCred;
bool isresponderVerified = false;

class AuthUser {
  String _email = "";
  String _password = "";
  late BuildContext _context;
  AuthUser({required email, required password, required BuildContext context}) {
    _email = email;
    _password = password;
    _context = context;

    resultLoginUser = "success";
    resultCreateUser = "success";
  }

  Future<UserCredential?> login() async {
    FirebaseAuth ref = FirebaseAuth.instance;
    try {
      userCred = await ref.signInWithEmailAndPassword(
          email: _email, password: _password);

      await FirebaseFirestore.instance
          .doc("responders/${FirebaseAuth.instance.currentUser!.uid}")
          .get()
          .then((value) {
        Map<String, dynamic>? data = value.data();
        isresponderVerified = data?["isResponderVerified"] ?? false;
      });

      if (userCred!.user != null) {
        prefs = await SharedPreferences.getInstance();
        prefs?.setString("email", _email);
        prefs?.setString("password", _password);
        prefs?.setBool("isResponderLoggedinBefore", true);
        if (userCred!.user!.emailVerified == true) {
          if (isresponderVerified == true) {
            Navigator.pushAndRemoveUntil(
                _context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                _context,
                MaterialPageRoute(
                    builder: (context) => const AlertResponderToVerify()),
                (route) => false);
          }
        } else {
          Navigator.pushAndRemoveUntil(
              _context,
              MaterialPageRoute(builder: (context) => const VerifyEmail()),
              (route) => false);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);

      AwesomeToaster.showToast(
          context: _context, msg: error.message.toString());
    }
    return userCred;
  }

  Future<String> signup({
    required String fullName,
    required String pswd,
  }) async {
    FirebaseAuth ref = FirebaseAuth.instance;
    FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
    try {
      await ref
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((value) {
        firestoreRef.doc("responders/${value.user!.uid}").set({
          "uid": value.user!.uid,
          "email": _email,
          "fullName": fullName,
          "pswd": pswd,
          "isResponderVerified": false,
        });
      }).then((value) async {
        return await ref.signInWithEmailAndPassword(
            email: _email, password: _password);
      }).then((value) async {
        FirebaseAuth.instance.currentUser!.updateDisplayName(fullName);
        FirebaseAuth.instance.currentUser!.updateEmail(_email);

        if (value.user != null) {
          prefs = await SharedPreferences.getInstance();
          prefs?.setString("email", _email);
          prefs?.setString("password", _password);
          prefs?.setBool("isResponderLoggedinBefore", true);
        }
        AwesomeToaster.showToast(
            context: _context, msg: "Account created successfully");
      });
    } on FirebaseAuthException catch (error) {
      resultCreateUser = error.message.toString();
    }

    if (resultCreateUser != "success") {
      AwesomeToaster.showToast(context: _context, msg: resultCreateUser);
    }
    return resultCreateUser;
  }
}
