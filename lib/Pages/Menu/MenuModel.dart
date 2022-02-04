// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';

class MenuModel {
  static const List<Color> iconColors = [
    Colors.purpleAccent,
    // Colors.blueAccent,
    Colors.redAccent,
    Colors.orangeAccent,
    // Colors.green,
    Colors.cyan
  ];

  static const List<String> title = [
    'AR - комната',
    // 'Фото-галерея',
    'Тесты',
    "Рекорды",
    // 'Настройки',
     'Пользователь'
  ];

  static const List<String> description = [
    'Несколько виртуальных комнат,разработанно специально для колледжа.',
    // 'Фото-галерея нашего музея.',
    'Проверка ваших знаний о нашем колледже.',
    'Только лучшие в списке',
    // 'Настройте приложение под себя',
    'Данные о пользователе',
  ];

  // static const List<String> _images = [
  //   'https://cdn.wallpapersafari.com/56/30/GQnAk8.jpg',
  //   'https://phonoteka.org/uploads/posts/2021-04/1619262090_21-phonoteka_org-p-kartinnaya-galereya-fon-22.jpg',
  //   'https://phonoteka.org/uploads/posts/2021-05/1621568830_10-phonoteka_org-p-kviz-fon-11.jpg',
  //   'https://i1.wp.com/www.mindful.org/content/uploads/Thrive.jpg?w=2000&ssl=1'

  // ];

  static const List<IconData> icons = [
    Icons.camera,
    // Icons.photo,
    Icons.list,
    Icons.offline_bolt,
    // Icons.settings,
    Icons.person
  ];
}

class MyCard extends StatelessWidget {
  final String title, description;
  final IconData icon;
  final Color iconColor;
  const MyCard(
      {Key? key,
      required this.iconColor,
      required this.description,
      required this.icon,
      // required this.imageLink,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(width: 2, color: iconColor),
        color: Colors.black.withOpacity(0.2),
      ),
      width: 150,
      height: 200,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Icon(
                icon,
                size: 50,
                color: iconColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: iconColor, width: 2)),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                description,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
