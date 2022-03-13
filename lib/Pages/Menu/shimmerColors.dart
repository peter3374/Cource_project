import 'package:flutter/material.dart';

class MenuColors {
  final List<Color> mainColor = [
    Colors.purpleAccent,
    Colors.indigo,
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.cyan
  ];

  final List<Color> shimmerHightlight = [
    Colors.purple,
    Colors.indigoAccent,
    Colors.pink,
    Colors.deepOrangeAccent,
    Colors.cyanAccent,
  ];

  final List<String> title = [
    'AR - комната',
    'Фото-галерея',
    'Блиц-опрос',
    "Рекорды",
    // 'Настройки',
    'Пользователь'
  ];

  final List<String> description = [
    'Несколько виртуальных комнат,разработанные специально для колледжа.',
    'Детальная фото-галерея нашего музея.',
    'Проверка ваших знаний о нашем колледже.',
    'Список результатов. Только лучшие в списке',
    // 'Настройте приложение под себя',
    'Статистика о пользователе.',
  ];

  final List<IconData> icons = [
    Icons.camera,
    Icons.photo,
    Icons.list,
    Icons.offline_bolt,
    Icons.person
  ];
}
