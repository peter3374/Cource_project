// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'package:cAR/Pages/Auth/authForm.dart';
import 'package:cAR/Pages/Menu/Menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DecisionTree extends StatefulWidget {
  //const DecisionTree({Key? key}) : super(key: key);
  @override
  State<DecisionTree> createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  @override
  void initState() {
    super.initState();
    var box = Hive.box('name');
    int appRunned = box.get('appRunned') ?? 0;
    appRunned++;
    box.put('appRunned', appRunned);
    onRefresh(
        FirebaseAuth.instance.currentUser); // keeps user (нет повторного входа)
  }

  @override
  void dispose() {
    super.dispose();
  }

  User? user;

  onRefresh(userCredential) {
    setState(() {
      user = userCredential;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Auth(
        onSignIn: (userCredential) => onRefresh(userCredential),
      );
    } else {
      return Menu(
        onSignOut: (userCred) => onRefresh(userCred),
      );
    }
  }
}
