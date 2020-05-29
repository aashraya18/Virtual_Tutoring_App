import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common_widgets/bottomFlatButton.dart';
import '../../../../services/custom_icons_icons.dart';

class StudentSlotScreen extends StatefulWidget {
  static const routeName = '/student-slot';
  @override
  _StudentSlotScreenState createState() => _StudentSlotScreenState();
}

class _StudentSlotScreenState extends State<StudentSlotScreen> {
  var selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          _buildText(),
          _buildDateList(constraints),
          Expanded(child: _buildTimeSlots(constraints)),
          BottomFlatButton(
            iconData: CustomIcons.user_add_outline,
            label: 'Schedule the Call',
            iconColor: Colors.white,
            textColor: Colors.white,
            iconSize: 25,
            textSize: 18,
            onPressed: null,
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
            lastDate: todayDate.add(Duration(days: 5)),
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

  Widget _buildTimeSlots(Size constraints) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: GridView.builder(
          itemCount: 15,
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: constraints.width / 2,
            childAspectRatio: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (ctx, index) => Center(
              child: Container(
            padding: const EdgeInsets.all(10),
            color: Color.fromRGBO(217, 243, 241, 1),
            child: Text('12:00 PM - 12:30 AM'),
          )),
        ),
      ),
    );
  }
}
