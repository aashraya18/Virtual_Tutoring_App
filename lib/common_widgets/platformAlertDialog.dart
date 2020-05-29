import 'package:flutter/material.dart';

class PlatformAlertDialog extends StatelessWidget {
  const PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);
  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions(context),
    );
  }

  List<Widget> actions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        FlatButton(
          child: Text(cancelActionText),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      FlatButton(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}
