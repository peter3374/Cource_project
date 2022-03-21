import 'dart:io';

import 'package:cAR/Pages/Auth/desicionAuth.dart';
import 'package:cAR/Pages/Menu/Menu.dart';
import 'package:cAR/Pages/Setup/setupPage.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wiredash/wiredash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
if(Platform.isAndroid || Platform.isIOS){
    await Firebase.initializeApp(); // firebase init
}
  //hive
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  await Hive.openBox('user_data'); // name;
  // set oriendation then run app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Wiredash(
        projectId: 'storm265-aml6s12',
        secret: 'G4cUKSHSqXind4BOOPQIPTBtYmkAwW2l',
        navigatorKey: _navigatorKey,
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Default',
          theme: ThemeData(
            // useMaterial3: true,
            scaffoldBackgroundColor: Colors.black,
            accentColor: Color(0xFC4C0C2), // buttons color
            primarySwatch: Colors.blue, // app bar
          ),
          home: Scaffold(
            backgroundColor: Colors.black,
               body: (Platform.isWindows) ? Menu(onSignOut: (User){}) : DecisionTree()
         //   body: SetupPage(),
          ),
        ));
  }
}
