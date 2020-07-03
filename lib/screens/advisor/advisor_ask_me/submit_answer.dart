
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SubmitAnswer extends StatefulWidget {
  static const routeName = '/submitAnswer';

  final String question;
  const SubmitAnswer({Key key, this.question}) : super(key: key);
  @override
  _SubmitAnswerState createState() => _SubmitAnswerState();
}

class _SubmitAnswerState extends State<SubmitAnswer> {
  final myController = TextEditingController();
  String answer;
  int maxLines = 5;
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40,horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Icon(
                            MdiIcons.helpCircle,
                            size: 30.0,
                            color: Colors.black38,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              widget.question,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.all(12),
                height: maxLines * 24.0,
                child: TextField(
                  maxLines: maxLines,
                  controller: myController,
                  decoration: new InputDecoration(
                    labelText: "Answer",
                    hintText: "Kindly answer here.....",
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      answer = text;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () => _updateDatabase(),
                color: Colors.teal,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 100.0, vertical: 15.0),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateDatabase() {
    log('$answer');
  }
}
