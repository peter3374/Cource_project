import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

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

  Color _onlineColor = Colors.greenAccent;
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
          _onlineColor = Colors.greenAccent;
        });
      } else {
        setState(() {
          _onlineColor = Colors.redAccent;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Привет, ${Hive.box('user_data').get('nickname') ?? 'Загрузка...'}'),
      ),
      body: SingleChildScrollView(
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
                    backgroundColor: _onlineColor,
                  ),
                ),
              ],
            )),
            Text(
              'Логин: ${Hive.box('user_data').get(
                    'email',
                  ) ?? 'Загрузка...'}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Пароль: ${Hive.box('user_data').get(
                    'password',
                  ) ?? 'Загрузка...'}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            // userCredential.user!.updatePassword('');

            const SizedBox(
              height: 10,
            ),
            Text(
              _onlineColor == Colors.redAccent ? 'В сети: Нет' : 'В сети: ДА',
              style: const TextStyle(color: Colors.white),
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
              'Количество попыток сдать тест: ${Hive.box('user_data').get('testRunned') ?? 0}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Количество посещений музея: ${Hive.box('user_data').get('arRunned') ?? 0}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Количество запусков приложения: ${Hive.box('user_data').get('appRunned') ?? 0}',
              style: const TextStyle(color: Colors.white),
            ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CustomTextField(
//                 isHiddenText: false,
//                 icon: Icons.lock,
//                 hintText: 'Новый Пароль:',
//                 textEditingController: _passwordController,
//               ),
//             ),

//             RaisedButton(
//                 color: Colors.blue,
//                 child: Text(
//                   'Обновить пароль',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                      if(_passwordController.text.length>=6){
// abstract class CustomDialogsCollection {
//                        FirebaseAuth.instance.currentUser!.updatePassword(_passwordController.text).then((value) => CustomDialogsCollection.showCustomSnackBar('Обновлено'));
//                      }

//                   });
//                   //
//                 }),

            // RaisedButton(
            //   onPressed: () {
            //     List<int> test = List.generate(10, (index) => index + 1);
            //     Hive.box('user_data')
            //         .put('list', test)
            //         .then((value) => print('saved'));
            //   },
            //   child: Text('Save list in db'),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     List test = List.generate(10, (index) => index + 1);
            //     var l = Hive.box('user_data').get('list');
            //     print(l);
            //   },
            //   child: Text('Get'),
            // ),
          ],
        ),
      ),
    );
  }
}
