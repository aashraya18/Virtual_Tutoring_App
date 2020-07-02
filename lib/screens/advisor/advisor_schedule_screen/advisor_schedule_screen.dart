import 'dart:developer';
import 'package:android/models/advisor_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AdvisorScheduleScreen extends StatefulWidget {
  AdvisorScheduleScreen({this.mentorUid});
  final String mentorUid;
  static const routeName = '/advisor-schedule';
  @override
  _AdvisorScheduleScreenState createState() => _AdvisorScheduleScreenState();
}

class _AdvisorScheduleScreenState extends State<AdvisorScheduleScreen> {
//  final formkey = new GlobalKey<FormState>();
//  final db = Firestore.instance;
//  String id;
//  String name;
  Advisor advisor;
  int slotStartTime;
  int slotEndTime;
  DateTime _dateTime;
  var dat;
  var mon;
  var yer;
  var date;
  var numberOfIndividualSlots = 1;
  var startTimeList = [for (var i = 9; i <= 22; i += 1) i];
  var endTimeList = [for (var i = 9; i <= 22; i += 1) i];
  List<String> individualSlotList = List<String>();
  Future<void> _showCalender() async {
    var nextSevenDays = DateTime.now().day + 6;
    var currentMonth = DateTime.now().month;
    var currentYear = DateTime.now().year;
    showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: DateTime.now(),
            lastDate: DateTime(currentYear, currentMonth, nextSevenDays))
        .then((date) {
      setState(() {
        _dateTime = date;
        dat = date.day;
        mon = date.month;
        yer = date.year;
      });
    });
  }

  void _makeList() {
    List<String> list = List<String>();
    var hour = slotStartTime;
    var minute = 0;
    do {
      minute == 0 ? list.add('$hour.00') : list.add('$hour.$minute');
      minute += 30;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour <= slotEndTime);
    list.removeAt(list.length - 1);
    print(list);
    for (var item = 0; item < list.length - 1; item++) {
      individualSlotList.add('${list[item]}-${list[item + 1]}');
    }
//    print(individualSlotList);
  }

//  void createData() async {
//    if (formkey.currentState.validate()) {
//      formkey.currentState.save();
//
//      DocumentReference ref = await db.collection('advisorslot').add({
//        'val1': '$slotStartTime',
//        'val2': '$slotEndTime',
//        'dateTime': '$_dateTime'
//      });
//      setState(() {
//        id = ref.documentID;
//      });
//      print(ref.documentID);
//      goToMainPage();
//    }
//  }
  void createMentorSlot() {
    String dateSelected = '$dat-$mon-$yer';
    String path = '/helpers/${advisor.email}/freeSlots/$dateSelected';
    DocumentReference documentReference = Firestore.instance.document(path);
    Map<String, dynamic> mentorSlot = {
      'NotBooked': individualSlotList,
    };
    documentReference.setData(mentorSlot, merge: true).whenComplete(() {
      log('completed');
    });
    Navigator.pushNamed(context, '/advisor-dashboard');
  }

//  void goToMainPage() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => AdvisorDashboardScreen()),
//    );
//  }
  Widget _buildImage() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Image.asset("assets/images/schedule.png"),
    );
  }

  Widget displayDate() {
    return Text("Date Selected : $dat-$mon-$yer",
        style: TextStyle(fontSize: 16));
  }

  Widget buildIndividualSlots(String slot, int slotNumber) {
    return Container(
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
                  'Slot $slotNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '$slot',
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
                  individualSlotList.removeAt(slotNumber - 1);
                  print(individualSlotList);
                  numberOfIndividualSlots -= 1;
                });
              },
              child:
                  Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
              textColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Color(0xffF1554C),
            ),
          )),
        ]),
      ),
    );
  }

  Widget createIndividualSlots() {
    List<Widget> individualSlots = [
      for (var i = 0; i < numberOfIndividualSlots; i += 1)
        buildIndividualSlots(
            individualSlotList.length == 0
                ? 'NULL-NULL'
                : individualSlotList[i],
            i + 1)
    ];
    return Column(
      children: individualSlots,
    );
  }

  @override
  Widget build(BuildContext context) {
    advisor = Provider.of<AuthProvider>(context).advisor;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            _buildImage(),
            Container(
              child: Column(
                children: [
                  RaisedButton(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Color(0xff0D276B),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text("SELECT DATE"),
                    onPressed: () async {
                      await _showCalender();
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: _dateTime == null
                        ? Text("SELECT COUNSELLING DATE",
                            style: TextStyle(color: Colors.black, fontSize: 16))
                        : displayDate(),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: 320,
                    height: 100,
                    color: Color(0xffF4F6FC),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  DropdownButton<int>(
                                    items: startTimeList
                                        .map((int dropDownIntItem) {
                                      return DropdownMenuItem<int>(
                                        value: dropDownIntItem,
                                        child: Text('$dropDownIntItem'),
                                      );
                                    }).toList(),
                                    onChanged: (int startSlot) {
                                      setState(() {
                                        slotStartTime = startSlot;
                                        endTimeList = [
                                          for (var i = slotStartTime;
                                              i <= 21;
                                              i += 1)
                                            i
                                        ];
                                        individualSlotList.clear();
                                        numberOfIndividualSlots = 1;
                                        slotEndTime = null;
                                      });
                                    },
                                    value: slotStartTime,
                                    hint: Text(
                                      'Select',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
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
                                DropdownButton<int>(
                                  dropdownColor: Color(0xffF4F6FC),
                                  items: endTimeList.map((int dropDownIntItem) {
                                    return DropdownMenuItem<int>(
                                      value: dropDownIntItem,
                                      child: Text('$dropDownIntItem'),
                                    );
                                  }).toList(),
                                  onChanged: (int endSlot) {
                                    setState(() {
                                      slotEndTime = endSlot;
                                      numberOfIndividualSlots =
                                          (slotEndTime - slotStartTime) * 2;
                                      _makeList();
                                    });
                                  },
                                  value: slotEndTime,
                                  hint: Text(
                                    'Select',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
//                  RaisedButton(
//                    onPressed: () {
//                      setState(() {
//                        slotStartTime = null;
//                        slotEndTime = null;
//                        numberOfIndividualSlots = 1;
//                        individualSlotList.clear();
//                      });
//                    },
//                    child:
//                    Text("RESET", style: TextStyle(fontSize:15.0,fontWeight: FontWeight.bold)),
//                    textColor: Colors.black,
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(8.0),
//                    ),
//                    color: Color(0xffFDB05E),
//                  ),
//                  SizedBox(
//                    height: 20.0,
//                  ),
                  createIndividualSlots(),
                  SizedBox(
                    height: 30.0,
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
                                createMentorSlot();
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
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

//  DropdownButton<String> buildDropdownButton() {
//    return new DropdownButton<String>(
//                                  dropdownColor: Color(0xffF4F6FC),
//                                  items: [
//                                    DropdownMenuItem<String>(
//                                      value: "10:00",
//                                      child: Text("10:00"),
//                                    ),
//                                    DropdownMenuItem<String>(
//                                      value: "13:00",
//                                      child: Text("13:00"),
//                                    ),
//                                    DropdownMenuItem<String>(
//                                      value: "15:00",
//                                      child: Text("15:00"),
//                                    )
//                                  ],
//                                  onChanged: (_value) {
//                                    setState(() {
//                                      slotStartTime = _value;
//                                    });
//                                  },
//                                  hint: Text(
//                                    slotStartTime == null
//                                        ? "Select"
//                                        : slotStartTime.toString(),
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.bold),
//                                  ),
//                                );
//  }
}

/* import 'package:cloud_firestore/cloud_firestore.dart';
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
 */
