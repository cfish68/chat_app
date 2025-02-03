import 'package:flutter/material.dart';
import 'package:chat_app/service/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 250),
              ElevatedButton(
                child: const Text("Sign Out"),
                onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen(),))//FirebaseAuth.instance.signOut(),
              ),
              ElevatedButton(child: Text("snackbar"),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("this is a snackbar"),)
              ),)
            ],
          ),
          ),
        )
    );
  }
}