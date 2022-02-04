import 'package:flutter/material.dart';

abstract class CustomDialogsCollection {
  static SnackBar showCustomSnackBar(String message) {
    return SnackBar(
        content: Container(
          child: Text(message),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5)),
          ),
        ),
        duration: const Duration(milliseconds: 1200));
  }
}
