import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
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
  var box = Hive.box('name');

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
    final nickName = box.get(
      'nickname',
    );
    int appRunned = box.get('appRunned') ?? 0;
    int arRunned = box.get('arRunned') ?? 0;
    int testRunned = box.get('testRunned') ?? 0;
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
                CircleAvatar(
                  maxRadius: 100,
                  backgroundImage: NetworkImage('${rndImageList[rnd]}'),
                ),
                Positioned(
                  right: 20,
                  top: 150,
                  child: CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: onlineColor,
                  ),
                ),
              ],
            )),
            Text(
              'Имя: $nickName',
              style: TextStyle(color: Colors.white),
            ),
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
            Text(
              'Создан профиль: ${DateFormat('yMd').format(DateTime.now())}',
              style: TextStyle(color: Colors.white),
            ),
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
