import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/auth_provider.dart';
import '../../../../services/custom_icons_icons.dart';
import '../../../../common_widgets/bottomFlatButton.dart';
import '../../../../models/student_model.dart';
import '../student_payment_screen/payments_screen.dart';
import '../student_payment_screen/order_id.dart';
import 'user_time_slot.dart';

class StudentSlotScreen extends StatefulWidget {
  static const routeName = '/student-slot';
  final advisor;
  final amount;
  const StudentSlotScreen({this.advisor, this.amount});

  @override
  _StudentSlotScreenState createState() => _StudentSlotScreenState();
}

class _StudentSlotScreenState extends State<StudentSlotScreen> {
  Student student;
  var selectedDate = DateTime.now();

  List<dynamic> mentorNotBookedSlotList = [];
  List<dynamic> mentorBookedSlotList = [];
  List<dynamic> studentBookedSlotList = List<dynamic>();
  List<dynamic> mentorBookedList = List<dynamic>();
  bool isTrue = false;
  String selectedSlot;
  bool isLoading = false;

  Stream<DocumentSnapshot> getData() {
    String advisorEmail = '${widget.advisor.email}';
    String dateSelected = DateFormat("dd-M-yyyy").format(selectedDate);
    String path = 'helpers/$advisorEmail/freeSlots/$dateSelected';
    return Firestore.instance.document(path).snapshots();
  }

  void _goToPaymentsScreen() async {
    setState(() {
      isLoading = true;
    });
    UserTimeSlot userTimeSlot = storeData();
    final OrderId order = OrderId(
      mentorId: '${widget.advisor.uid}',
      mentorName: '${widget.advisor.displayName}',
      amount: widget.amount,
    );
    String orderId = await order.generateOrderId();
    if (isTrue) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PaymentsScreen(
            cartTotal: widget.amount,
            mentorId: '${widget.advisor.uid}',
            mentorName: '${widget.advisor.displayName}',
            orderId: orderId,
            userTimeSlot: userTimeSlot,
          ),
        ),
      );
    } else {
      /* Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => StudentDashboardScreen())); */
    }
  }

  void _slotSelection(index) {
    setState(() {
      isTrue = true;
      selectedSlot = '${mentorNotBookedSlotList[index]}';
    });
  }

  UserTimeSlot storeData() {
    if (selectedSlot != "No Slot Selected") {
      studentBookedSlotList.add(selectedSlot);
      if (studentBookedSlotList.isNotEmpty) {
        for (var value in studentBookedSlotList) {
          if (mentorNotBookedSlotList.contains(value)) {
            mentorNotBookedSlotList.remove(value);
          }
        }
      }
      for (var value in studentBookedSlotList) {
        mentorBookedList.add(value);
      }
    }
    UserTimeSlot slotSelected = UserTimeSlot(
      studentBookedSlotList: studentBookedSlotList,
      mentorBookedList: mentorBookedList,
      dateSelected: DateFormat("dd-M-yyyy").format(selectedDate),
      advisorEmail: '${widget.advisor.email}',
      mentorNotBookedSlotList: mentorNotBookedSlotList,
      studentEmail: '${student.email}',
    );
    return slotSelected;
  }

  Stream<DocumentSnapshot> getStudentData() {
    String dateSelected = DateFormat("dd-M-yyyy").format(selectedDate);
    String path =
        '/studentSlot/${student.email}/${widget.advisor.email}/$dateSelected';
    return Firestore.instance.document(path).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<AuthProvider>(context).student;
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          _buildText(),
          _buildDateList(constraints),
          Expanded(child: _buildAvailableSlots(constraints)),
          _buildSelectedSlot(),
          BottomFlatButton(
            iconData: CustomIcons.user_add_outline,
            label: 'Schedule the Call',
            iconColor: Colors.white,
            textColor: Colors.white,
            iconSize: 25,
            textSize: 18,
            loading: isLoading,
            onPressed: _goToPaymentsScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select the Time Slot',
            style: TextStyle(fontSize: 22),
          ),
          Text(
            'for your call',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDateList(Size constraints) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 3,
      color: Theme.of(context).primaryColor,
      child: FlatButton(
        child: Text(
          DateFormat.yMMMd().format(selectedDate),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          final todayDate = DateTime.now();
          final date = await showDatePicker(
            context: context,
            initialDate: todayDate,
            firstDate: todayDate,
            lastDate: todayDate.add(Duration(days: 7)),
          );
          if (date == null) {
            return;
          }
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _buildAvailableSlots(Size constraints) {
    return Column(
      children: <Widget>[
        Text(
          'Available Slots',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                mentorNotBookedSlotList = snapshot.data['NotBooked'];
                if (mentorNotBookedSlotList != null) {
                  return Container(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: constraints.width / 2,
                            childAspectRatio: 4,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (ctx, index) => _buildSlot(index),
                          itemCount: mentorNotBookedSlotList.length,
                        ),
                      ));
                } else {
                  return Card(
                    child: Center(
                      child: Text(
                        "No Slots Avaiable",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildSelectedSlot() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        'Selected Slot',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
      Container(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: isTrue
              ? Text('$selectedSlot')
              : Text(
                  "No Slot Selected",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
        ),
      ),
    ]);
  }

  Widget _buildSlot(int index) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: () => _slotSelection(index),
      color: Color.fromRGBO(217, 243, 241, 1),
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Text('${mentorNotBookedSlotList[index]}')),
    );
  }
}
