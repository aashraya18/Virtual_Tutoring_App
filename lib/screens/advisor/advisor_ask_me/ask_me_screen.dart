import 'dart:async';
import 'package:android/screens/advisor/advisor_ask_me/submit_answer.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:android/models/advisor_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CurrentTab {
  pastQuestion,
  newQuestion,
}

class AskMeScreen extends StatefulWidget {
  static const routeName = '/askMeScreen';
  @override
  _AskMeScreenState createState() => _AskMeScreenState();
}

class _AskMeScreenState extends State<AskMeScreen> {
  CurrentTab _currentTab = CurrentTab.newQuestion;
  Advisor advisor;
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    advisor = Provider.of<AuthProvider>(context).advisor;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _buildPastQuestion()),
              Expanded(child: _buildNewQuestion()),
            ],
          ),
          _buildTabBottomColor(),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey[400],
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_currentTab == CurrentTab.pastQuestion) return _buildPast();
    return _buildNew();
  }

  Widget _buildPastQuestion() {
    getNewQuestions();
    return _buildTab(
      context: context,
      tabTitle: 'Past Question',
      child: '',
      color: Colors.blue,
      onPressed: _currentTab == CurrentTab.pastQuestion
          ? null
          : () {
              setState(() {
                _currentTab = CurrentTab.pastQuestion;
              });
            },
    );
  }

  Widget _buildNewQuestion() {
    return _buildTab(
      context: context,
      tabTitle: 'New Question',
      child: '',
      color: Colors.blue,
      onPressed: _currentTab == CurrentTab.newQuestion
          ? null
          : () {
              setState(() {
                _currentTab = CurrentTab.newQuestion;
              });
            },
    );
  }

  Widget _buildTab({
    @required BuildContext context,
    @required String tabTitle,
    @required String child,
    @required Function onPressed,
    @required Color color,
  }) {
    final constraints = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        height: constraints.height * 0.13,
        width: constraints.width / 3,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(child),
            Text(
              tabTitle,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _buildTabBottomColor() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 3,
            color: _currentTab == CurrentTab.pastQuestion
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: 3,
            color: _currentTab == CurrentTab.newQuestion
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildPast() {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: getPastQuestions(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  'No Questions Answered',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              );
            return new Column(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 3,
                    child: Theme(
                      data: ThemeData(accentColor: Colors.teal),
                      child: ExpansionTile(
                        title: Row(
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
                                  document['Question'],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    MdiIcons.heart,
                                    size: 20.0,
                                    color: Colors.teal,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '${document['Likes']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              document['Answer'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => SubmitAnswer(
                                          question: document["Question"],
                                          id: document["ID"],
                                        ))),
                            color: Colors.teal,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 5.0),
                              child: Text(
                                'Edit',
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
              }).toList(),
            );
          }),
    );
  }

  Widget _buildNew() {
    return StreamBuilder<QuerySnapshot>(
        stream: getNewQuestions(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => SubmitAnswer(
                        question: document["Question"],
                        id: document.documentID))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 3,
                    child: Theme(
                      data: ThemeData(accentColor: Colors.teal),
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
                                  document['Question'],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                MdiIcons.arrowRight,
                                size: 30.0,
                                color: Colors.teal,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }

  Stream<QuerySnapshot> getNewQuestions() {
    String advisorEmail = '${advisor.email}';
    String path = 'helpers/$advisorEmail/askMe';
    return Firestore.instance
        .collection(path)
        .where("isAnswered", isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getPastQuestions() {
    String advisorEmail = '${advisor.email}';
    String path = 'helpers/$advisorEmail/askMe';
    return Firestore.instance
        .collection(path)
        .where("isAnswered", isEqualTo: true)
        .orderBy("Likes", descending: true)
        .snapshots();
  }
}
