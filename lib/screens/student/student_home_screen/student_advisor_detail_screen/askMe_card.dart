
import 'dart:developer';

import 'package:android/models/advisor_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AskMeCard extends StatefulWidget {
  static const routeName = '/submitAnswer';
  @override
  _AskMeCardState createState() => _AskMeCardState();
}

class _AskMeCardState extends State<AskMeCard> {
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
              Container(
                margin: EdgeInsets.all(12),
                height: maxLines * 24.0,
                child: TextField(
                  maxLines: maxLines,
                  controller: myController,
                  decoration: new InputDecoration(
                    hintText: "Ask a question",
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
//                onPressed: () => _updateDatabase(),
                color: Colors.teal,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 100.0, vertical: 15.0),
                  child: Text(
                    'Ask',
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

//  void _updateDatabase() {
//    String path = '/helpers/${advisor.email}/askMe/${widget.id}';
//    DocumentReference documentReference = Firestore.instance.document(path);
//    Map<String, dynamic> updateAskMe = {
//      'Answer' : answer,
//      'isAnswered' : true,
//    };
//    documentReference.updateData(updateAskMe);
//    Navigator.of(context).pop();
//  }
}
