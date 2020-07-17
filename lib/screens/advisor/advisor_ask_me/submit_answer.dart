
import 'dart:developer';

import 'package:android/models/advisor_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SubmitAnswer extends StatefulWidget {
  static const routeName = '/submitAnswer';

  final String question;
  final String id;
  const SubmitAnswer({Key key, this.question, this.id}) : super(key: key);
  @override
  _SubmitAnswerState createState() => _SubmitAnswerState();
}

class _SubmitAnswerState extends State<SubmitAnswer> {
  final myController = TextEditingController();
  String answer;
  int maxLines = 5;
  Advisor advisor;
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    advisor = Provider.of<AuthProvider>(context).advisor;
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
    String path = '/helpers/${advisor.email}/askMe/${widget.id}';
    DocumentReference documentReference = Firestore.instance.document(path);
    Map<String, dynamic> updateAskMe = {
      'Answer' : answer,
      'isAnswered' : true,
    };
    documentReference.updateData(updateAskMe);
    Navigator.of(context).pop();
  }
}
