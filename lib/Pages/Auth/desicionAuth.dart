// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'package:cAR/Pages/Auth/authForm.dart';
import 'package:cAR/Pages/Menu/Menu.dart';
import 'package:cAR/Pages/Setup/setupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DecisionTree extends StatefulWidget {
  const DecisionTree({Key? key}) : super(key: key);
  @override
  State<DecisionTree> createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  @override
  void initState() {
    super.initState();
int appRunnedTimes = Hive.box('user_data').get('appRunned') ?? 0;
    appRunnedTimes++;
    Hive.box('user_data').put('appRunned', appRunnedTimes);
  
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

  Future<bool> _getVisitedTime() async {
    if (Hive.box('user_data').get('isFirstTime') == null) {
      
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Auth(
        // auth
        onSignIn: (userCredential) => onRefresh(userCredential),
      );
    } else {
      return FutureBuilder(
          future: _getVisitedTime(),
          builder: (context, snapshots) {
            if (snapshots.data == true) {
              return SetupPage();
            } else {
              return Menu(
                onSignOut: (userCred) => onRefresh(userCred),
              );
            }
          });
    }
  }
}
