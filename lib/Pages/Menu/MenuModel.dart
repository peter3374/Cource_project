// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';

abstract class MenuModel {
  static const List<Color> iconColors = [
    Colors.purpleAccent,
    Colors.indigo,
    // Colors.blueAccent,
    Colors.redAccent,
    Colors.orangeAccent,
    // Colors.green,
    Colors.cyan
  ];

  static const List<String> title = [
    'AR - комната',
    'Фото-галерея',
    'Блиц-опрос',
    "Рекорды",
    // 'Настройки',
    'Пользователь'
  ];

  static const List<String> description = [
    'Несколько виртуальных комнат,разработанные специально для колледжа.',
    'Детальная фото-галерея нашего музея.',
    'Проверка ваших знаний о нашем колледже.',
    'Список результатов. Только лучшие в списке',
    // 'Настройте приложение под себя',
    'Статистика о пользователе.',
  ];

  // static const List<String> _images = [
  //   'https://cdn.wallpapersafari.com/56/30/GQnAk8.jpg',
  //   'https://phonoteka.org/uploads/posts/2021-04/1619262090_21-phonoteka_org-p-kartinnaya-galereya-fon-22.jpg',
  //   'https://phonoteka.org/uploads/posts/2021-05/1621568830_10-phonoteka_org-p-kviz-fon-11.jpg',
  //   'https://i1.wp.com/www.mindful.org/content/uploads/Thrive.jpg?w=2000&ssl=1'

  // ];

  static const List<IconData> icons = [
    Icons.camera,
    Icons.photo,

    Icons.list,
    Icons.offline_bolt,
    // Icons.settings,
    Icons.person
  ];
}

// class MenuCard extends StatefulWidget {
//   final Color color;
//   int index = 0;
//   final IconData icon;
//   final String title, description;
//    MenuCard(
//       {Key? key,
//       required this.color,
//       required this.icon,
//       required this.description,
//       required this.title})
//       : super(key: key);

//   @override
//   State<MenuCard> createState() => _MenuCardState();
// }

// class _MenuCardState extends State<MenuCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 320,
//       width: 250,
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 5,
//           ),
//           Icon(widget.icon, size: 65, color: widget.color),
//           const SizedBox(
//             height: 10,
//           ),
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: widget.color, width: 2)),
//             child: Text(
//               widget.title,
//               style: const TextStyle(color: Colors.white, fontSize: 22),
//             ),
//           ),
//           const SizedBox(
//             height: 12,
//           ),
//           Text(
//             widget.description,
//             style: const TextStyle(
//                 fontSize: 21, color: Colors.white, fontWeight: FontWeight.w300),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//       decoration: BoxDecoration(
//           color: Colors.black45,
//           border: Border.all(color: widget.color, width: 3),
//           borderRadius: BorderRadius.circular(9)),
//     );
//   }
// }
