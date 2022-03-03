import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final VoidCallback method;
  final IconData icon;
  final String text;
  const CustomAuthButton(
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

class SetupBotton extends StatelessWidget {
  final VoidCallback method;

  final String text;
  const SetupBotton({
    Key? key,
    required this.text,
    required this.method,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: method,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 40,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
