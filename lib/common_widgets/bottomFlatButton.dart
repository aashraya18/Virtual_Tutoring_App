import 'package:flutter/material.dart';

class BottomFlatButton extends StatelessWidget {
  const BottomFlatButton({
    @required this.iconData,
    @required this.label,
    @required this.onPressed,
    this.textColor,
    this.iconColor,
    this.iconSize,
    this.textSize,
    this.loading: false,
  })  : assert(iconData != null),
        assert(label != null);

  final IconData iconData;
  final String label;
  final Color textColor;
  final Color iconColor;
  final double iconSize;
  final double textSize;
  final Function onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        color: Theme.of(context).primaryColor,
        height: constraints.height * 0.08,
        width: constraints.width,
        child: loading
            ? Center(
                child: CircularProgressIndicator(backgroundColor: textColor))
            : Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconData,
                    color: iconColor,
                    size: iconSize,
                  ),
                  SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                    ),
                  ),
                ],
              ),
      ),
      onTap: onPressed,
    );
  }
}
