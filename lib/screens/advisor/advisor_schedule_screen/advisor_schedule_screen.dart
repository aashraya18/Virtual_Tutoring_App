import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvisorScheduleScreen extends StatefulWidget {
  static const routeName = '/advisor-schedule';
  @override
  _AdvisorScheduleScreenState createState() => _AdvisorScheduleScreenState();
}

class _AdvisorScheduleScreenState extends State<AdvisorScheduleScreen> {
  final formkey = new GlobalKey<FormState>();
  int val1;
  int val2;
  final db = Firestore.instance;
  String id;
  String uid;
  var _dateTime = DateTime.now();
  String name;
  String aduser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<DropdownMenuItem<String>> _fromTimeList =
      List<DropdownMenuItem<String>>.generate(
          12, (index) => DropdownMenuItem(child: Text('${index + 8}:00')));

  DateTime _selectedDate;

  Future<void> _showpicker() async {
    final todayDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: todayDate,
      firstDate: todayDate,
      lastDate: todayDate.add(Duration(days: 6)),
    );
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void createdata() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      final FirebaseUser user = await _auth.currentUser();
      final uid = user.uid;
      setState(() {
        aduser = uid;
      });
      DocumentReference ref = await db.collection('advisorslot').add({
        'val1': '$val1',
        'val2': '$val2',
        'dateTime': '$_dateTime',
        'unid': '$aduser'
      });
      setState(() {
        id = ref.documentID;
      });
      print(ref.documentID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            child: Image.asset("assets/images/schedule.png"),
          ),
          _buildSelectDateButton(context),
          SizedBox(height: 40.0),
          Form(
            key: formkey,
            child: Column(
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                "From",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              new DropdownButton<String>(
                                dropdownColor: Color(0xffF4F6FC),
                                items: _fromTimeList,
                                onChanged: (_value) {},
                                hint: Text(
                                  val1 == null
                                      ? "Select"
                                      : val1.toString() + ':00',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Column(children: [
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "To",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new DropdownButton<int>(
                              dropdownColor: Color(0xffF4F6FC),
                              items: [
                                DropdownMenuItem<int>(
                                  value: 11,
                                  child: Text("11:00"),
                                ),
                                DropdownMenuItem<int>(
                                  value: 14,
                                  child: Text("14:00"),
                                ),
                                DropdownMenuItem<int>(
                                  value: 16,
                                  child: Text("16:00"),
                                ),
                              ],
                              onChanged: (_value) {
                                setState(() {
                                  val2 = _value;
                                });
                              },
                              hint: Text(
                                val2 == null
                                    ? "Select"
                                    : val2.toString() + ':00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                        )
                      ],
                    )),
                SizedBox(
                  height: 23.0,
                ),
                RaisedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Center(child: Text("Make Available")),
                        actions: [
                          RaisedButton(
                            onPressed: () {
                              createdata();
                            },
                            child: Text("Yes"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          SizedBox(
                            width: 53,
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text("No"),
                          ),
                          SizedBox(width: 27.0)
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      barrierDismissible: true,
                    );
                  },
                  child: Text("Make Available"),
                  color: Color(0xffFDB05E),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(
                  height: 21,
                ),
                Container(
                  width: 320,
                  height: 100,
                  color: Color(0xffF4F6FC),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 28,
                            ),
                            Text(
                              val1 == null ? "From : NULL" : "From :    $val1",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              val2 == null ? "To : NULL" : "To :    $val2",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.black,
                      ),
                      Expanded(
                          child: Center(
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              val1 = null;
                              val2 = null;
                            });
                          },
                          child: Text("Cancel",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: Color(0xffF1554C),
                        ),
                      )),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSelectDateButton(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Text(_selectedDate != null
          ? '${DateFormat('d/M/y, E').format(_selectedDate)}'
          : 'Select Date'),
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context).accentColor,
      onPressed: _showpicker,
    );
  }
}
