import 'dart:developer';
import 'dart:io';

import 'package:cAR/Pages/Menu/Menu.dart';
import 'package:cAR/Widgets/CustomButton.dart';

import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

late bool _isArModuleInstalled = false;
late bool _isArServiesInstalled = false;

class SetupPage extends StatefulWidget {
  // final Function(User?) onSignIn;
  // SetupPage({Key? key, required this.onSignIn}) : super(key: key);
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int _seletedItem = 0; // page index
  final _pages = [
    // Insert your pages here
    Page1(),
    Page2(),
  ];
  final _pageController = PageController();
  User? user;

  onRefresh(userCredential) {
    setState(() {
      user = userCredential;
    });
  }

  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            if (Platform.isIOS) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Menu(
                        onSignOut: (userCredential) =>
                            onRefresh(userCredential),
                      )));
            }
            setState(() {
              if (!_isArModuleInstalled && !_isArServiesInstalled) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Установите необходимые сервисы😐')));
              } else if (!_isArModuleInstalled) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Установите модуль 😐')));
              } else if (!_isArServiesInstalled) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Установите сервисы 😐')));
              } else {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => Menu(
                //           onSignOut: (userCredential) =>
                //               onRefresh(userCredential),
                //         )));
              }

              if (_seletedItem >= 2) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Menu(
                          onSignOut: (userCredential) =>
                              onRefresh(userCredential),
                        )));
              }
              _seletedItem++;
              _pageController.animateToPage(_seletedItem,
                  duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
            });
          }),
      body: PageView(
        // use you physics
        physics: const BouncingScrollPhysics(),
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _seletedItem = index;
            log('$_seletedItem');
          });
        },
        controller: _pageController,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Добро пожаловать',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showDialog() {
    return showDialog(
        barrierColor: Colors.black54,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Приложение не установлено'),
            actions: [
              TextButton(
                  onPressed: () =>
                      launch('https://disk.yandex.ru/d/waW-2rRhsgwLZw'),
                  child: Text('Скачать'))
            ],
          );
        });
  }

  Future<bool> _getARModule() async {
    await Future.delayed(Duration(seconds: 1));
    bool isInstalled =
        await DeviceApps.isAppInstalled('com.NoStudio.ColledgeAR');
    return isInstalled;
  }

  Future<bool> _getARServices() async {
    await Future.delayed(Duration(seconds: 1));
    bool isInstalled = await DeviceApps.isAppInstalled('com.google.ar.core');
    return isInstalled;
  }

  Color _tweenStartColor = Colors.black;
  Color _tweenEndColor = Colors.cyan;
  _firstColorSwitch() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _tweenEndColor = Colors.pink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
        onEnd: () {
          _firstColorSwitch();
          setState(() {
            _tweenEndColor = Colors.green;
            _tweenEndColor = Colors.cyan;
          });
        },
        child: null,
        tween: ColorTween(begin: _tweenStartColor, end: _tweenEndColor),
        duration: const Duration(seconds: 7),
        builder: (_, Color? color, __) {
          return ColoredBox(
              color: color!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 60,
                  ),
                  const Text(
                    'Для продолжения работы требуется проверка установленных компонентов.',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FutureBuilder(
                          future: _getARModule(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '1) Проверка наличие \n установленных AR-сервисов',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  Tooltip(
                                    message: _isArServiesInstalled
                                        ? 'Установлено'
                                        : 'Не установлено',
                                    child: const CircleAvatar(
                                        backgroundColor: Colors.white10,
                                        child: CircularProgressIndicator()),
                                  ),
                                ],
                              );
                            } else if (snapshot.data == false) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '1) Проверка наличие \n установленных AR-сервисов',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                      Tooltip(
                                          message: _isArServiesInstalled
                                              ? 'Установлено'
                                              : 'Не установлено',
                                          child: const CircleAvatar(
                                              backgroundColor: Colors.white10,
                                              child: Icon(
                                                Icons.error_outline_rounded,
                                                color: Colors.red,
                                              ))),
                                    ],
                                  ),
                                  CustomAuthButton(
                                      text: 'Установить',
                                      method: () => launch(
                                          'https://disk.yandex.ru/d/waW-2rRhsgwLZw'),
                                      icon: Icons.shopping_bag),
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '1) Проверка наличия \n установленных AR-сервисов',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  Tooltip(
                                      message: _isArServiesInstalled
                                          ? 'Установлено'
                                          : 'Не установлено',
                                      child: const CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          child: Icon(Icons.done))),
                                ],
                              );
                            }
                          })),
                  //2
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FutureBuilder(
                          future: _getARServices(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '2) Проверка наличия \n второстепенного AR-модуля',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  Tooltip(
                                    message: _isArServiesInstalled
                                        ? 'Установлено'
                                        : 'Не установлено',
                                    child: const CircleAvatar(
                                        backgroundColor: Colors.white10,
                                        child: CircularProgressIndicator()),
                                  ),
                                ],
                              );
                            } else if (snapshot.data == false) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '2) Проверка наличия \n второстепенного AR-модуля',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                      Tooltip(
                                          message: _isArModuleInstalled
                                              ? 'Установлено'
                                              : 'Не установлено',
                                          child: const CircleAvatar(
                                              backgroundColor: Colors.white10,
                                              child: Icon(
                                                Icons.error_outline_rounded,
                                                color: Colors.red,
                                              ))),
                                    ],
                                  ),
                                  CustomAuthButton(
                                      text: 'Установить',
                                      method: () => launch(
                                          'https://play.google.com/store/apps/details?id=com.google.ar.core&hl=ru&gl=US'),
                                      icon: Icons.shopping_bag),
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '2) Проверка наличия \n второстепенного AR-модуля',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  Tooltip(
                                      message: _isArModuleInstalled
                                          ? 'Установлено'
                                          : 'Не установлено',
                                      child: const CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          child: Icon(Icons.done))),
                                ],
                              );
                            }
                          })),
                ],
              ));
        });
  }
}
