import 'dart:developer';
import 'package:android/models/student_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common_widgets/bottomFlatButton.dart';
import '../student_slot_screen/student_slot_screen.dart';

enum TimeSelected {
  rs90,
  rs100,
  rs250,
}

class StudentTimeScreen extends StatefulWidget {
  static const routeName = '/student-time';
  final advisor;
  final student;
  const StudentTimeScreen({Key key, this.advisor,this.student}) : super(key: key);
  @override
  _StudentTimeScreenState createState() => _StudentTimeScreenState();
}

class _StudentTimeScreenState extends State<StudentTimeScreen> {
  TimeSelected _timeSelected = TimeSelected.rs90;
  double amount;
  List<String> couponCodes = ["None"];
  var _category;
  Map<String, int> couponMap = Map<String, int>();
  Map<String, String> couponIdMap = Map<String, String>();
  bool isDiscountApplied = false;
  String discountId;

  @override
  void initState() {
    couponMap["None"] = 0;
    super.initState();
    generateCouponList().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

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

    try {
      var discount = couponMap[_category];
      log('$discount');
      amount = amount * (100 - discount) / 100;
      log('$amount');
      isDiscountApplied = true;
      discountId = couponIdMap[_category];

    } catch (e) {}
    finally{
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StudentSlotScreen(
            advisor: widget.advisor,
            amount: amount,
            isDiscountApplied: isDiscountApplied,
            discountId: discountId,
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
      ),
      body: Center(
        child: Column(
//          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildText(),
            Center(
              child: _buildTimeCard(
                  time: '25', money: '90', selected: TimeSelected.rs90),
            ),

//            _buildTimeCard(
//                time: '30', money: '100', selected: TimeSelected.rs100),
//            _buildTimeCard(
//                time: '60', money: '250', selected: TimeSelected.rs250),
            _buildCouponText(),
            _buildCoupon(),
            _buildCouponList(),
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

  Widget _buildCoupon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
      child: Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            items: couponCodes.map((String category) {
              return new DropdownMenuItem(
                  value: category,
                  child: Column(
                    children: <Widget>[
                      Text(category),
                    ],
                  ));
            }).toList(),
            onChanged: (newValue) {
              // do other stuff with _category
              setState(() => _category = newValue);
            },
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
            value: _category,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20, 20, 10, 20),
              filled: true,
              fillColor: Colors.white,
              hintText: "Choose Coupon",
              border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
//          errorText:
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponList() {
    return StreamBuilder<QuerySnapshot>(
        stream: getCoupons(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.grey[100],
                  elevation: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text('${document.data["CouponCode"]}'),
                        Text('${document.data["CouponDescription"]}')
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }

  Widget _buildCouponText() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select Coupon',
            style: TextStyle(fontSize: 21),
          ),
        ],
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

  Stream<QuerySnapshot> getCoupons() {
    String studentUid = widget.student.uid;
    String path = '/students/$studentUid/coupons';
    return Firestore.instance
        .collection(path)
        .orderBy("CouponValue")
        .snapshots();
  }

  Future<void> generateCouponList() async {
    String studentUid = widget.student.uid;
    String path = '/students/$studentUid/coupons';
    await Firestore.instance.collection(path).getDocuments().then((result) {
      result.documents.forEach((result) {
        couponCodes.add(result.data["CouponCode"]);
        couponMap[result.data["CouponCode"]] = result.data["CouponValue"];
        couponIdMap[result.data["CouponCode"]] = result.documentID;
      });
    });
    log('$couponCodes');
    log('$couponMap');
  }
}
