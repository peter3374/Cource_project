// ignore_for_file: file_names

import 'dart:math';

import 'package:cAR/CustomButton/CustomButton.dart';
import 'package:cAR/model/isAnonim.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Auth extends StatefulWidget {
  final Function(User?) onSignIn;
  Auth({Key? key, required this.onSignIn}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var _subscription;
  @override
  void initState() {
    super.initState();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);
      if (result == ConnectivityResult.none) {
        _internetRequiredDialog();
      }
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.wifi) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Подключен к интернету.')));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _internetRequiredDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
                'Для работы приложения требуется интернет соединение!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              )
            ],
          );
        });
  }

  Future<void> _infoDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
                'Аномнимный вход предоставляет доступ только к комнате и фото-галереи.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              )
            ],
          );
        });
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';
  bool _isLogin = true;

  Future<void> _loginAnonim() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      widget.onSignIn(userCredential.user);
    } catch (e) {
      print('Исключение метода входа анонимно');
    }
  }

  Future<void> createUser() async {
    if (_emailController.text == '' && _passwordController.text == '') {
      _showSnackBar('Поля не могут быть пустыми.');
    } else if (_passwordController.text.length < 6) {
      _showSnackBar('Длинна пароля должна быть > 6 символов.');
    } else if (_passwordController.text.length < 6) {
      _showSnackBar('Введите корректно почту.');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        widget.onSignIn(userCredential.user);

        // hive
        var box = Hive.box('name');
        box.put('nickname', _emailController.text);
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.toString().contains(
              'The email address is already in use by another account')) {
            _showSnackBar('Пользователь с такой почтой уже существует.');
          }
          if (e.toString().contains(
              'There is no user record corresponding to this identifier. The user may have been deleted.')) {
            _showSnackBar('Пользователь не существует. Создайте аккаунт.');
          }
          if (e.toString().contains('The email address is badly formatted.')) {
            _emailController.text = "";
            _showSnackBar('Введен некорректный адрес почты!');
          } else if (e.toString().contains('Given String is empty or null')) {
            _showSnackBar('Пароль не может быть пустым.');
          } else {
            _error = e.message.toString();
          }
        });
      }
    }
  }

  Future<void> _loginUser() async {
    if (_emailController.text == '' && _passwordController.text == '') {
      _showSnackBar('Поля не могут быть пустыми.');
    } else if (_passwordController.text.length < 6) {
      _showSnackBar('Длинна пароля должна быть >6 символов.');
    } else {
      try {
        // hive
        var box = Hive.box('name');
        box.put('nickname', _emailController.text);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        widget.onSignIn(userCredential.user);
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.toString().contains(
              'The email address is already in use by another account')) {
            _showSnackBar('Пользователь с такой почтой уже существует.');
          }
          if (e.toString().contains(
              'The password is invalid or the user does not have a password.')) {
            _showSnackBar('Неверный пароль.');
          }
          if (e.toString().contains(
              'There is no user record corresponding to this identifier. The user may have been deleted.')) {
            _showSnackBar('Пользователь не существует. Создайте аккаунт.');
          }
          if (e.toString().contains('The email address is badly formatted.')) {
            _emailController.text = "";
            _showSnackBar('Введен некорректный адрес почты!');
          } else if (e.toString().contains('Given String is empty or null')) {
            _showSnackBar('Пароль не может быть пустым.');
          } else {
            _error = e.message.toString();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('assets/login.png'))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 250,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 180),
                  child: Text(
                    'Музей',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 39),
                  child: Text(
                    'Изучай, развлекайся, познавай',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // fields
                CustomTextField(
                  isHiddenText: false,
                  icon: Icons.mail,
                  hintText: 'Email:',
                  textEditingController: _emailController,
                ),
                CustomTextField(
                  isHiddenText: true,
                  icon: Icons.lock,
                  hintText: 'Пароль:',
                  textEditingController: _passwordController,
                ),
                Text(
                  _error,
                  style: TextStyle(color: Colors.white),
                ),
                // Buttons

                CustomButton(
                  icon: Icons.assignment_ind,
                  method: () {
                    _isLogin ? _loginUser() : createUser();
                  },
                  text: _isLogin ? 'Войти' : "Создать",
                ),
                CustomButton(
                  icon: Icons.assignment_ind,
                  method: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  text: "Сменить вход/создать",
                ),

                CustomButton(
                  icon: Icons.perm_identity,
                  method: () {
                    _loginAnonim();
                    IsAnonim.isAnonim = true;
                  },
                  text: 'Аноним',
                ),
                GestureDetector(
                  onTap: () {
                    _infoDialog();
                  },
                  child: const Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final bool isHiddenText;

  const CustomTextField(
      {Key? key,
      required this.isHiddenText,
      required this.textEditingController,
      required this.hintText,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          counterStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white60, fontSize: 18),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        enableSuggestions: true, // hints on keyboard
        obscureText: isHiddenText,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        toolbarOptions: const ToolbarOptions(
            copy: true, cut: true, paste: true, selectAll: true),
        textInputAction: TextInputAction.go,
        onSubmitted: (String value) {},
        controller: textEditingController,
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        maxLength: 30,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
