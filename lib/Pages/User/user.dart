import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var _subscription;
  @override
  void initState() {
    super.initState();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);

      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.wifi) {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  // const UserProfile({ Key? key }) : super(key: key);

  List<String> rndImageList = [
    'https://www.youredm.com/wp-content/uploads/2019/03/Graham-John-Bell-for-Insomniac-Events-1.jpg',
    'https://steamuserimages-a.akamaihd.net/ugc/912414619787869094/35B2177C29BA2B94FE9C5200094D87411EB430B6/?imw=512&amp;imh=341&amp;ima=fit&amp;impolicy=Letterbox&amp;imcolor=%23000000&amp;letterbox=true',
    'https://www.ixbt.com/img/n1/news/2020/7/0/Science_BillGates_1174744356_large.jpg',
    'https://insdrcdn.com/media/attachments/a/88/9e0ff288a.jpg'
  ];

  final rnd = Random().nextInt(3);
  Color onlineColor = Colors.greenAccent;
  @override
  Widget build(BuildContext context) {
    final _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);

      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.wifi) {
        setState(() {
          onlineColor = Colors.greenAccent;
        });
      } else {
        setState(() {
          onlineColor = Colors.redAccent;
        });
      }
    });
    // for output
    final nickName = Hive.box('user_data').get(
      'nickname',
    );
    int appRunned = Hive.box('user_data').get('appRunned') ?? 0;
    int arRunned = Hive.box('user_data').get('arRunned') ?? 0;
    int testRunned = Hive.box('user_data').get('testRunned') ?? 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Привет, $nickName'),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Stack(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  maxRadius: 70,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 90,
                  ),
                  //    backgroundImage: NetworkImage('${rndImageList[rnd]}'),
                ),
                Positioned(
                  right: 20,
                  top: 80,
                  child: CircleAvatar(
                    maxRadius: 16,
                    backgroundColor: onlineColor,
                  ),
                ),
              ],
            )),
            Text(
              'Логин: $nickName',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            RaisedButton(
                color: Colors.blue,
                child: Text(
                  'Обновить пароль',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  FirebaseAuth.instance.currentUser!.updatePassword('');
                }),
            // userCredential.user!.updatePassword('');

            const SizedBox(
              height: 10,
            ),
            Text(
              onlineColor == Colors.redAccent ? 'В сети: Нет' : 'В сети: ДА',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            // Text(
            //   'Создан профиль: ${FirebaseAuth.instance.currentUser.photoURL}',
            //   style: TextStyle(color: Colors.white),
            // ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Количество попыток сдать тест: $testRunned',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Количество посещений музея: $arRunned',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Количество запусков приложения: $appRunned',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
