// ignore_for_file: file_names

import 'dart:developer';

import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:cAR/Pages/Menu/MenuModel.dart';
import 'package:cAR/Pages/Menu/TurnOff.dart';
import 'package:cAR/Pages/RecordList/RecordList.dart';
import 'package:cAR/Pages/User/user.dart';
import 'package:cAR/Pages/quiz/Quiz.dart';

import 'package:cAR/Widgets/dialogs.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:wiredash/wiredash.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final Function(User) onSignOut;

  const Menu({Key? key, required this.onSignOut}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  final _scrollController = FixedExtentScrollController();
  String _imagePath = 'ar';

  late final Animation<double> _animation =
      Tween<double>(begin: 0, end: 1.0).animate(_controller);
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1650),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();

    /// short fix
    if (Hive.box('user_data').get('isFirstTime') == null) {
      Hive.box('user_data').put('isFirstTime', false);
    }

    _controller.forward(); // run animation
    {
      int appRunned = Hive.box('user_data').get('appRunned') ?? 0;
      appRunned++;
      Hive.box('user_data').put('appRunned', appRunned);
    }
    _getARModule().then((value) => (value)
        ? print('ok')
        : CustomDialogsCollection.showCustomSnackBar('no'));
    _getARServives().then(
        (value) => (value) ? log('ar installed') : log('ar not installed'));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<bool> _getARModule() async {
    bool isInstalled =
        await DeviceApps.isAppInstalled('com.NoStudio.ColledgeAR');
    return isInstalled;
  }

  Future<bool> _getARServives() async {
    bool isInstalled = await DeviceApps.isAppInstalled('com.google.ar.core');
    return isInstalled;
  }

  int _changedIndex = 0;
  Color _floatIconColor = Colors.purple;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switch (_changedIndex) {
            case 0:
              int arRunned = Hive.box('user_data').get('arRunned') ?? 0;
              arRunned++;
              Hive.box('user_data').put('arRunned', arRunned);

              // _showDialog();

              DeviceApps.openApp('com.NoStudio.ColledgeAR');

              break;
            case 1:
             int photoRunned = Hive.box('user_data').get('photoRunned') ?? 0;
              photoRunned++;
              Hive.box('user_data').put('testRunned', photoRunned);

              setState(() {
                _imagePath = 'gallery';
                _floatIconColor = MenuModel.iconColors[1];
              });
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => QuizzScreen()));
              break;
            case 2:
              int testRunned = Hive.box('user_data').get('testRunned') ?? 0;
              testRunned++;
              Hive.box('user_data').put('testRunned', testRunned);
              log('record list');

              setState(() {
                _imagePath = 'quiz';
                _floatIconColor = MenuModel.iconColors[2];
              });
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => QuizzScreen()));
              break;
            case 3:
              setState(() {
                _imagePath = 'records';
                _floatIconColor = MenuModel.iconColors[3];
              });
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => RecordList()));
              break;
            case 4:
              setState(() {
                _imagePath = 'stats';
                _floatIconColor = MenuModel.iconColors[4];
              });
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => UserProfile()));
              break;
          }
        },
        backgroundColor: _floatIconColor,
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TurnOffPage()));
            },
            child: const Hero(
              tag: 'turnOff',
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.power_settings_new,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        title: const Text('Меню'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Wiredash.of(context)!.show();
          },
          child: const Tooltip(
            message: 'Отправить баг',
            child: Icon(
              Icons.bug_report,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          color: _floatIconColor,
        )),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/backgrounds/$_imagePath.jpg')),
            ),
            width: double.infinity,
            height: double.infinity,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 4),
                child: ListWheelScrollView.useDelegate(
                  onSelectedItemChanged: ((value) {
                    setState(() {
                      _changedIndex = value;
                      log('$_changedIndex');
                    });
                    switch (_changedIndex) {
                      case 0:
                        setState(() {
                          _imagePath = 'ar';
                          _floatIconColor = MenuModel.iconColors[0];
                        });
                        break;
                      case 1:
                        int testRunned =
                            Hive.box('user_data').get('testRunned') ?? 0;
                        testRunned++;
                        Hive.box('user_data').put('testRunned', testRunned);

                        setState(() {
                          _imagePath = 'gallery';
                          _floatIconColor = MenuModel.iconColors[1];
                        });

                        break;
                      case 2:
                        log('record list');

                        setState(() {
                          _imagePath = 'quiz';
                          _floatIconColor = MenuModel.iconColors[2];
                        });

                        break;
                      case 3:
                        setState(() {
                          _imagePath = 'records';
                          _floatIconColor = MenuModel.iconColors[3];
                        });

                        break;
                      case 4:
                        setState(() {
                          _imagePath = 'stats';
                          _floatIconColor = MenuModel.iconColors[4];
                        });

                        break;
                    }
                  }),
                  itemExtent: 320,
                  controller: _scrollController,
                  offAxisFraction: 0.8,
                  squeeze: 0.7,
                  diameterRatio: 3,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                      childCount: MenuModel.iconColors.length,
                      builder: ((context, index) =>
                          // MenuCard(
                          //       color: MenuModel.iconColors[index],
                          //       description: MenuModel.description[index],
                          //       icon: MenuModel.icons[index],
                          //       title: MenuModel.title[index],
                          //     )
                          Container(
                            height: 320,
                            width: 250,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Icon(MenuModel.icons[index],
                                    size: 65,
                                    color: MenuModel.iconColors[index]),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                            color: MenuModel.iconColors[index],
                                            blurRadius: 14)
                                      ],
                                      border: Border.all(
                                          color: MenuModel.iconColors[index],
                                          width: 2)),
                                  child: Text(
                                    MenuModel.title[index],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  MenuModel.description[index],
                                  style: const TextStyle(
                                      fontSize: 21,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                border: Border.all(
                                    color: MenuModel.iconColors[index],
                                    width: 3),
                                borderRadius: BorderRadius.circular(9)),
                          ))),
                ),
              ),
            )),
      ),
    );
  }
}
