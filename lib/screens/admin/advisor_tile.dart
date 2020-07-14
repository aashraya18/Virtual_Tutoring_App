import 'package:android/services/advisor_database_provider.dart';
import 'package:flutter/material.dart';
import 'package:android/models/advisor_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BuildTile extends StatefulWidget {
  BuildTile({this.advisor});
  Advisor advisor;

  @override
  _BuildTileState createState() => _BuildTileState();
}

class _BuildTileState extends State<BuildTile> {
  Map pay ;

  getPayment(BuildContext context) async{
    var temp = await Provider.of<AdvisorDatabaseProvider>(context).getAdvisorDetails(widget.advisor.email, 'Payment');
    setState(() {
      pay = temp;
    });
  }
  @override
  Widget build(BuildContext context) {
    getPayment(context);
    bool f = true;
    if(pay == null || pay['status'] == '')
       f = false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListTile(
          leading: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(widget.advisor.photoUrl),
            ),
          ),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Container(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.advisor.displayName,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text('Amount:'),
                  (f)?Text(pay['Amount'].toString()):Text('0'),
                ],
              ),
              Row(
                children: [
                  Text('Guided:'),
                  (f)?Text(pay['GuidedStudents'].toString()):Text('0'),
                ],
              ),
              Row(
                children: [
                  (f)?Text(pay['UpiID']):Text('Not given'),
                ],
              ),
              Row(
                children: [
                  Text('Mode:'),
                  (f)?Text(pay['mode'].toString()):Text('Not given'),
                ],
              ),
              Row(
                children: [
                  Text('Number:'),
                  (f)?Text(pay['Number'].toString()):Text('Not given'),
                ],
              ),
            ],
          ),
        ),
        RaisedButton(
          onPressed: (){
            setState(() {
              pay ={
                'Amount': pay['Amount'],
                'GuidedStudents': pay['GuidedStudents'],
                'status' : 'Approved',
                'UpiID': pay['UpiID'],
                'mode':pay['mode'],
              };
            });
            Firestore.instance.collection('helpers').document(widget.advisor.email).updateData({'Payment':pay});
          },
          color:  (f)?Colors.greenAccent:Colors.red,
          child: (f)? Text(pay['status']):Text('Not applicable'),
          ),
          ],
        ),
       ),
     ),
    );
  }
}
