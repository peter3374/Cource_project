import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback method;
  final IconData icon;
  final String text;
  const CustomButton(
      {Key? key, required this.text, required this.method, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: method,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 40,
        width: 200,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child:
                  // Icons.arrow_back_ios_new_outlined
                  Icon(icon, color: Colors.white),
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
