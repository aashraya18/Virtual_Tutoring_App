import 'dart:developer';

import 'package:android/models/student_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../services/student_database_provider.dart';
import '../../../../models/advisor_model.dart';
import '../../../../models/review_model.dart';
import '../../../../models/mentee_model.dart';
import './review_card.dart';
import './askMe_card.dart';
import 'package:like_button/like_button.dart';

enum CurrentTab {
  about,
  reviews,
  askMe,
  askMeQuestion,
}

class AdvisorTabBar extends StatefulWidget {
  const AdvisorTabBar(this.advisor,this.tabNumber);
  final int tabNumber;
  final Advisor advisor;

  @override
  _AdvisorTabBarState createState() => _AdvisorTabBarState();
}

class _AdvisorTabBarState extends State<AdvisorTabBar> {
  final myController = TextEditingController();
  CurrentTab _currentTab;
  Student student;
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _currentTab = widget.tabNumber == 1 ? CurrentTab.about : widget.tabNumber == 2 ? CurrentTab.reviews : CurrentTab.askMe;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    student = Provider.of<AuthProvider>(context).student;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildAboutColumn(),
            _buildReviewsColumn(),
            _buildAskMeColumn(),
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
    );
  }

  Widget _buildBody() {
    if (_currentTab == CurrentTab.reviews) return _buildReviews();
    if (_currentTab == CurrentTab.askMe) return _buildAskMe();
    if (_currentTab == CurrentTab.askMeQuestion) return _buildAskMeQuestion();
    return _buildAbout();
  }

  Widget _buildAbout() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sharing my experience with aspiring students',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.advisor.about,
                style: TextStyle(fontSize: 17),
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return StreamBuilder<List<Review>>(
        stream: Provider.of<StudentDatabaseProvider>(context)
            .getAdvisorReviews(widget.advisor.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reviews = snapshot.data;
            if (reviews.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (ctx, index) => ReviewCard(reviews[index]),
                itemCount: reviews.length,
              );
            } else {
              return Center(child: Text('No reviews yet.'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildAskMe() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: getPastQuestions(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      'No Questions',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  );
                return new Column(
                  children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                    List<dynamic> whoLiked = document["whoLiked"];
                    bool previouslyLiked = whoLiked != null
                        ? whoLiked.contains('${student.email}')
                        : false;
                    log('$previouslyLiked');
                    var likes = document['Likes'];
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
                                  width: 5.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: <Widget>[
                                      LikeButton(
                                        size: 20.0,
                                        onTap: (isLiked) =>
                                            onLikeButtonTapped(
                                                id: document.documentID,
                                                like: isLiked
                                                    ? likes -= 1
                                                    : likes += 1,
                                                isLiked: isLiked),
                                        likeCount: likes,
                                        isLiked: previouslyLiked ? true : false,
                                      )
//                                          : Row(
//                                              children: <Widget>[
//                                                Icon(
//                                                  MdiIcons.heart,
//                                                  color: Colors.red,
//                                                ),
//                                                SizedBox(
//                                                  width: 5.0,
//                                                ),
//                                                Text(
//                                                  '$likes',
//                                                  textAlign: TextAlign.center,
//                                                  style: TextStyle(
//                                                    fontSize: 15.0,
//                                                    color: Colors.black87,
//                                                    fontWeight: FontWeight.w400,
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
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
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                setState(() {
                  _currentTab = CurrentTab.askMeQuestion;
                });
              },
              color: Colors.teal[400],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Ask a question',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    Icon(
                      MdiIcons.arrowRight,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
// Advisor Ask me
  Widget _buildAskMeQuestion() {
    int maxLines = 5;
    String answer;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(12),
              height: maxLines * 24.0,
              child: TextField(
                controller: myController,
                maxLines: maxLines,
                decoration: new InputDecoration(
                  hintText: "Ask a question",
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  setState(() {
                    var answer = text;
                    log('$answer');
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
              onPressed: myController.text != ""
                  ? () => _updateDatabase(myController.text)
                  : () {
                setState(() {
                  log('$answer');
                  myController.clear();
                  _currentTab = CurrentTab.askMe;
                });
              },
              color: Colors.teal,
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 100.0, vertical: 15.0),
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
    );
  }

  Widget _buildAboutColumn() {
    return _buildTab(
      context: context,
      tabTitle: 'About',
      child: Text(''),
      color: Colors.blue,
      onPressed: _currentTab == CurrentTab.about
          ? null
          : () {
        setState(() {
          _currentTab = CurrentTab.about;
        });
      },
    );
  }

  Widget _buildReviewsColumn() {
    return _buildTab(
      context: context,
      tabTitle: 'Reviews',
      child: Text(widget.advisor.reviewsCount.toString()),
      color: Colors.black,
      onPressed: _currentTab == CurrentTab.reviews
          ? null
          : () {
        setState(() {
          _currentTab = CurrentTab.reviews;
        });
      },
    );
  }

  Widget _buildAskMeColumn() {
    return _buildTab(
      context: context,
      tabTitle: 'Ask me!',
      child: Icon(MdiIcons.forum),
      color: Colors.red,
      onPressed: _currentTab == CurrentTab.askMe
          ? null
          : () {
        setState(() {
          _currentTab = CurrentTab.askMe;
        });
      },
    );
  }

  Widget _buildTab({
    @required BuildContext context,
    @required String tabTitle,
    @required Widget child,
    @required Function onPressed,
    @required Color color,
  }) {
    final constraints = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        height: constraints.height * 0.1,
        width: constraints.width / 3,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            child,
            Text(tabTitle),
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
            color: _currentTab == CurrentTab.about
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: 3,
            color: _currentTab == CurrentTab.reviews
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: 3,
            color: _currentTab == CurrentTab.askMe
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
      ],
    );
  }

  Stream<QuerySnapshot> getPastQuestions() {
    String advisorEmail = '${widget.advisor.email}';
    String path = 'helpers/$advisorEmail/askMe';
    return Firestore.instance
        .collection(path)
        .where("isAnswered", isEqualTo: true)
        .orderBy("Likes", descending: true)
        .snapshots();
  }

  void _updateDatabase(question) {
    log(' Before raised button :$question');
    String path = '/helpers/${widget.advisor.email}/askMe';
    Map<String, dynamic> askMeQuestion = {
      "Question": question,
      'Answer': "",
      'isAnswered': false,
      'Likes': 0,
    };
    Firestore.instance.collection(path).add(askMeQuestion);
    setState(() {
      _currentTab = CurrentTab.askMe;
      myController.clear();
    });
  }

  Future<bool> onLikeButtonTapped({bool isLiked, like, id}) async {
    String path = '/helpers/${widget.advisor.email}/askMe/$id';
    Map<String, dynamic> likes = {
      'Likes': like,
      'whoLiked': isLiked
          ? FieldValue.arrayRemove(['${student.email}'])
          : FieldValue.arrayUnion(['${student.email}']),
    };
    Firestore.instance.document(path).setData(likes, merge: true);
    return !isLiked;
  }
}