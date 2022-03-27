// ignore_for_file: file_names

import 'package:cAR/data/quizData.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String title;
  final String time;
  final int score;

  const TaskWidget({
    Key? key,
    required this.score,
    required this.title,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Text(''),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
            '$score/${Questions().questions.length}',
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2)),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
        title: Text(
          '$title ',
          softWrap: true,
          maxLines: 3,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
