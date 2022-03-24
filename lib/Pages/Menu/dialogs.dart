import 'package:cAR/Pages/Menu/dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskListDialogs {
  Future<void> showAddDialog(BuildContext context) => showDialog(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {
        return AlertDialog(
          
          title: const Text('Установите сервисы!😡'),
          actions: [
            TaskListDialogButtons(
              icon: Icons.add_task_outlined,
              text: 'Скачать модуль',
              method: () => launch('https://disk.yandex.ru/d/waW-2rRhsgwLZw'),
            ),
            TaskListDialogButtons(
              icon: Icons.post_add_outlined,
              text: 'Скачать сервисы',
              method: () => launch(
                  'https://play.google.com/store/apps/details?id=com.google.ar.core&hl=ru&gl=US'),
            ),
          ],
        );
      });
}
