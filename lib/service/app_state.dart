import 'dart:async';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'
  hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserState extends ChangeNotifier {
  UserState(){
    init();
  }
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;


  String? _currentUserEmail = "";
  String? get currentUserEmail => _currentUserEmail;


  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
    FirebaseAuth.instance.userChanges().listen((user){
      if(user != null) {
        _loggedIn = true;
        _currentUserEmail = FirebaseAuth.instance.currentUser?.email;
        debugPrint('logged in console message');
        if(FirebaseAuth.instance.currentUser?.metadata.creationTime == FirebaseAuth.instance.currentUser?.metadata.lastSignInTime){
          //add user to firestore0
        }
      } else {
        _loggedIn = false;
        debugPrint('logged out console message');
      }
      notifyListeners();
      
    });
  }
  Future<String> getUserName() async {
  // Check if the currentUser is null or email is null
  String? email = FirebaseAuth.instance.currentUser?.email;

  // If email is null, return a default value (like an empty string)
  return email ?? 'No email found';  // You can change 'No email found' to a custom message
}
}
