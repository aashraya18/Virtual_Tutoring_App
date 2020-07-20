import 'package:android/models/student_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/bottomFlatButton.dart';
import '../../../../common_widgets/platformAlertDialog.dart';
import '../../../../models/advisor_model.dart';
import '../student_slot_screen/student_slot_screen.dart';

enum TimeSelected {
  rs90,
  rs100,
  rs250,
}

class StudentTimeScreen extends StatefulWidget {
  static const routeName = '/student-time';
  final advisor;
  const StudentTimeScreen({Key key, this.advisor}) : super(key: key);
  @override
  _StudentTimeScreenState createState() => _StudentTimeScreenState();
}

class _StudentTimeScreenState extends State<StudentTimeScreen> {
  TimeSelected _timeSelected;
  double amount;
  void _setTime() {
    if (_timeSelected == null) {
      return;
    }
//    final advisor = ModalRoute.of(context).settings.arguments as Advisor;
    double amount;
    if (_timeSelected == TimeSelected.rs90)
      amount = 9000;
    else if (_timeSelected == TimeSelected.rs100)
      amount = 10000;
    else if (_timeSelected == TimeSelected.rs250) amount = 25000;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StudentSlotScreen(
              advisor: widget.advisor,
              amount: amount ,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildText(),
            Center(
              child: _buildTimeCard(
                  time: '25', money: '200', selected: TimeSelected.rs90),
            ),

//            _buildTimeCard(
//                time: '30', money: '100', selected: TimeSelected.rs100),
//            _buildTimeCard(
//                time: '60', money: '250', selected: TimeSelected.rs250),
            Spacer(),
            BottomFlatButton(
              iconData: Icons.access_time,
              label: 'Select the Time Slot',
              iconColor: Colors.white,
              textColor: Colors.white,
              iconSize: 25,
              textSize: 18,
              onPressed: () => _setTime(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select the call duration',
            style: TextStyle(fontSize: 22),
          ),
          Text(
            'with the Advisor',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard({
    @required String time,
    @required String money,
    @required TimeSelected selected,
  }) {
    final constraints = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        child: Container(
          width: constraints.width * 0.6,
          height: constraints.height * 0.075,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '$time min',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: _timeSelected == selected
                            ? Theme.of(context).primaryColor
                            : Color.fromRGBO(153, 221, 218, 1),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Rs. $money',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: _timeSelected == selected
            ? null
            : () {
                setState(() {
                  _timeSelected = selected;
                  amount = double.parse(money);
                });
              },
      ),
    );
  }
}
