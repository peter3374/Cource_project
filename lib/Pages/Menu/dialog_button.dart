import 'package:flutter/material.dart';

class TaskListDialogButtons extends StatelessWidget {
  String text;
  IconData icon;
  VoidCallback method;
  TaskListDialogButtons(
      {Key? key, required this.icon, required this.method, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        label: Text(text), icon: Icon(icon), onPressed: method);
  }
}
