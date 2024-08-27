import 'package:flutter/material.dart';
import 'package:tito_app/core/constants/style.dart';

class PurpleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  final OutlinedBorder shape;
  final EdgeInsetsGeometry padding;

  PurpleButton({
    required this.text,
    required this.onPressed,
    this.color = ColorSystem.purple,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.all(16.0),
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
        padding: WidgetStateProperty.all(padding),
        shape: WidgetStateProperty.all(shape),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
