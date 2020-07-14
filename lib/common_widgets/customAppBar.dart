import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;
  final Color color;
  CustomAppBar({@required this.child, this.height,this.color});
  @override
  Size get preferredSize => Size.fromHeight(height);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: preferredSize.height,
      alignment: Alignment.center,
      child: child,
    );
  }
}