import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../services/student_database_provider.dart';
import '../../../models/review_model.dart';
import '../../../common_widgets/bottomFlatButton.dart';
import '../../../common_widgets/platformAlertDialog.dart';

class StudentFeedbackScreen extends StatefulWidget {
  static const routeName = '/student-feedback';
  @override
  _StudentFeedbackScreenState createState() => _StudentFeedbackScreenState();
}

class _StudentFeedbackScreenState extends State<StudentFeedbackScreen> {
  final _reviewFormKey = GlobalKey<FormState>();
  final _headlineTextCont = TextEditingController();
  final _reviewTextCont = TextEditingController();

  double _rating = 0.0;
  bool _submitting = false;

  Future<void> _submitReview() async {
    if (_rating == 0.0) {
      PlatformAlertDialog(
        title: 'No Rating provided',
        content: 'Enter some rating.',
        defaultActionText: 'Okay',
      ).show(context);
      return;
    }

    if (!_reviewFormKey.currentState.validate()) return;
    try {
      setState(() {
        _submitting = true;
      });
      final arguments =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      await Provider.of<StudentDatabaseProvider>(context, listen: false)
          .addReview(
              arguments['advisorEmail'],
              Review(
                heading: _headlineTextCont.text,
                review: _reviewTextCont.text,
                stars: _rating,
              ));
      Navigator.of(context).pop();
      _submitting = false;
    } catch (error) {
      setState(() {
        _submitting = false;
      });
      PlatformAlertDialog(
        title: 'Error occured.',
        content: error.toString(),
        defaultActionText: 'Okay',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor Rating'),
        centerTitle: true,
      ),
      body: Form(
        key: _reviewFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildQuestionBar(constraints, arguments['advisorName']),
              SizedBox(height: 10),
              _buildRating(),
              SizedBox(
                height: 10,
              ),
              _buildHeadlineTTF(),
              _buildReviewTTF(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomFlatButton(
        label: 'Submit Rating',
        iconData: Icons.check_circle_outline,
        textColor: Theme.of(context).accentColor,
        iconColor: Theme.of(context).accentColor,
        textSize: 20,
        loading: _submitting,
        onPressed: _submitReview,
      ),
    );
  }

  Widget _buildQuestionBar(Size constraints, String advisorName) {
    return Container(
      height: constraints.height * 0.1,
      alignment: Alignment.center,
      color: Theme.of(context).primaryColor,
      child: Text(
        'How was $advisorName as a Mentor?',
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return SmoothStarRating(
      allowHalfRating: false,
      onRated: (v) {
        _rating = v;
      },
      starCount: 5,
      rating: 0.0,
      size: 40.0,
      isReadOnly: false,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      color: Theme.of(context).primaryColor,
      borderColor: Theme.of(context).primaryColor,
      spacing: 0.0,
    );
  }

  Widget _buildHeadlineTTF() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
      child: Card(
        elevation: 2,
        child: TextFormField(
          controller: _headlineTextCont,
          decoration: InputDecoration(
            labelText: 'Add a headline',
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) return 'Write something';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildReviewTTF() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
      child: Card(
        elevation: 2,
        child: TextFormField(
          controller: _reviewTextCont,
          decoration: InputDecoration(
            labelText: 'Write your Review',
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          maxLines: 6,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) return 'Write something';
            return null;
          },
        ),
      ),
    );
  }
}
