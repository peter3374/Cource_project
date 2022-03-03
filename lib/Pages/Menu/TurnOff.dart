import 'dart:io';

import 'package:flutter/material.dart';

class TurnOffPage extends StatelessWidget {
  TurnOffPage({Key? key}) : super(key: key);
  double right = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Hero(
        tag: 'turnOff',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TurnOffCustomButton(
                method: () => exit(0),
                iconData: Icons.power_settings_new,
                text: 'Выйти из приложения'),
            TurnOffCustomButton(
                method: () => Navigator.pop(context),
                iconData: Icons.arrow_back_ios_new,
                text: 'Вернуться'),
          ],
        ),
      )),
    );
  }
}

class TurnOffCustomButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback method;
  final String text;
  const TurnOffCustomButton(
      {Key? key,
      required this.method,
      required this.iconData,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: method,
          child: Icon(
            iconData,
            size: 150,
            color: Colors.white,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 26, color: Colors.white),
        ),
      ],
    );
  }
}
