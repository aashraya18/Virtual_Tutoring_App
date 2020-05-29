import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    this.iconColor,
    this.iconSize,
  });

  final Color iconColor;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: iconColor ?? Colors.white70,
          size: iconSize ?? 33,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }
}
