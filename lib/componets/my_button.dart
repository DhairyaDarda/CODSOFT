import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;

  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 100,
      height: 40,
      onPressed: onPressed,
      color: Colors.yellow[700],
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
