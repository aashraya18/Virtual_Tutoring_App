import 'package:android/screens/advisor/advisor_ask_me/ask_me_screen.dart';
import 'package:flutter/material.dart';

class AnswerQuestionTile extends StatelessWidget {
  void _goToAskMe(BuildContext context) {
    Navigator.of(context).pushNamed(AskMeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: height * 0.1,
          width: width,
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Text(
                  'Answer the Qs',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 25),
                ),
              )
            ),
          ),
        ),
      ),
      onTap: () => _goToAskMe(context),
    );
  }
}
