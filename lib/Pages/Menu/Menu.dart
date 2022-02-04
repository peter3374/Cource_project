// ignore_for_file: file_names

import 'dart:io';
import 'dart:ui';

import 'package:cAR/CustomButton/CustomButton.dart';
import 'package:cAR/Pages/Menu/MenuModel.dart';
import 'package:cAR/Pages/Quiz.dart';
import 'package:cAR/Pages/RecordList/RecordList.dart';
import 'package:cAR/Pages/Settings/settings.dart';
import 'package:cAR/Pages/User/user.dart';
import 'package:cAR/model/isAnonim.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wiredash/wiredash.dart';

import 'package:device_apps/device_apps.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final Function(User) onSignOut;

  Menu({Key? key, required this.onSignOut}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var box = Hive.box('name');

    if (box.get('arRunned') == null) {
      box.put('arRunned', 1);
    }
  }

  final ll = null;

  int _selectedIndex = 0;

// working bad (not recommended to use)
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    widget.onSignOut(ll);
  }

  var box = Hive.box('name');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/menu.jpg')),
          ),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Wiredash.of(context)!.show();
                      },
                      child: const Icon(
                        Icons.feedback_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const Text(
                      "Меню:",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ],
                ),

                const Divider(color: Colors.white),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: IsAnonim.isAnonim == true ? 1 : 4, //2 5
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 23,
                        mainAxisSpacing: 23,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _selectedIndex = index;

                            switch (_selectedIndex) {
                              case 0:
                                try {
                                  int appRunned = box.get('arRunned') ?? 0;
                                  ;
                                  appRunned++;
                                  box.put('arRunned', appRunned);

                                  DeviceApps.openApp('com.NoStudio.ColledgeAR');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Установите Ar-приложение'),
                                          duration: Duration(seconds: 2)));
                                }

                                break;

                              case 1:
                                int testRunned = box.get('testRunned') ?? 0;
                                testRunned++;
                                box.put('testRunned', testRunned);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const QuizzScreen()));
                                break;
                              case 2:
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>  RecordList()));
                                break;
                              // case 3:
                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) => const Settings()));
                              //   break;
                              case 3:
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserProfile()));
                                break;
                            }
                          },
                          child: MyCard(
                            iconColor: MenuModel.iconColors[index],
                            description: MenuModel.description[index],
                            icon: MenuModel.icons[index],
                            title: MenuModel.title[index],
                          ),
                        );
                      }),
                ),
                // CustomButton(
                //     text: "Выйти из аккаунта",
                //     method: () {
                //       logout();
                //       exit(0);
                //     },
                //     icon: Icons.exit_to_app),
                CustomButton(
                    text: "Закрыть приложение",
                    method: () => exit(0),
                    icon: Icons.close),
              ],
            ),
          )),
    );
  }
}
