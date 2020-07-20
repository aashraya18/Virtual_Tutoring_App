import 'package:android/services/advisor_database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvisorPaymentsScreen extends StatefulWidget {
  static const routeName = '/advisor-payments';

  @override
  _AdvisorPaymentsScreenState createState() => _AdvisorPaymentsScreenState();
}

class _AdvisorPaymentsScreenState extends State<AdvisorPaymentsScreen> {
  Map payment;
  String amount;
  String guidedStudents;
  String status;
  String emailID;
  bool allowed = false;
  TextEditingController upiCtrl = TextEditingController();
  TextEditingController numCtrl = TextEditingController();
  bool phonePe = false;
  bool gPay = false;
  String mode ;
  bool upi = true;

  getAmount(BuildContext context) async{
    FirebaseUser email = await FirebaseAuth.instance.currentUser();
    emailID = email.email;
    print(emailID);
    payment = await Provider.of<AdvisorDatabaseProvider>(context,listen: false).getAdvisorDetails(emailID, 'Payment');
    setState(() {
      amount = payment['Amount'].toString();
      upiCtrl.text = payment['UpiID'];
      guidedStudents = payment['GuidedStudents'].toString();
      status = payment['status'];
      if(status == "allowed" || status == "Approved")
        allowed = true;
    });

  }


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getVideoCallStatus();
    getAmount(context);
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Image.asset('assets/images/payments.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                        'Total Amount:',
                         style: TextStyle(
                           fontWeight: FontWeight.w700,
                           fontSize: 25,
                          ),
                        ),
                       amount!=null? Text(
                          ' $amount Rs',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),
                        ):
                        Padding(
                          padding: const EdgeInsets.only(left:5),
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(top:15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total no. of students guided:',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          guidedStudents!=null?Text(
                            guidedStudents,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ):
                          Padding(
                            padding: const EdgeInsets.only(left:5),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:20.0,left:100,right:100),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                        'Payment Methods',
                       style: TextStyle(
                         fontSize: 25,
                         fontWeight: FontWeight.w700
                       ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:40,right:40),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left:15,right:15,top:15),
                      height: 63,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(14),topLeft: Radius.circular(14)),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:30.0,top:15,bottom: 15),
                            child: Image.asset('assets/images/upi.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child: Checkbox(
                                value:upi,
                                checkColor: Colors.white,
                                focusColor: Colors.white,
                                activeColor: Color(0xFF1F6A71),

                                onChanged: (value) {
                                  setState(() {
                                    if(upi == false){
                                      gPay = false;
                                      phonePe = false;
                                      mode ='UPI';
                                    }
                                    upi = !upi;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          height:40,
                          color: Color(0xFFE4E4E4),
                          child: Padding(
                            padding: const EdgeInsets.only(top:20.0,left: 30.0),
                            child: TextField(
                              controller: upiCtrl,
                              style: TextStyle(
                                fontFamily: 'Literal',
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter UPI ID...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          margin: (upi)?EdgeInsets.only(left:15,right: 15,top:60):EdgeInsets.only(left:15,right: 15),
                          height: 63,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:30.0,top:10,bottom: 10),
                                child: Image.asset('assets/images/gpay.png'),
                              ),
                              Text('Google Pay',style: TextStyle(color: Colors.white,fontSize: 23,fontFamily: 'Literal',fontWeight: FontWeight.w200),),
                              Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Checkbox(
                                    value:gPay,
                                    checkColor: Colors.white,
                                    focusColor: Colors.white,
                                    activeColor: Color(0xFF1F6A71),

                                    onChanged: (value) {
                                      setState(() {
                                        if(gPay == false){
                                          phonePe = false;
                                          upi = false;
                                          mode = 'Gpay';
                                          mode = 'Gpay';
                                        }
                                        gPay = !gPay;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          height:40,
                          color: Color(0xFFE4E4E4),
                          child: Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 30.0),
                            child: TextField(
                              controller: numCtrl,
                              style: TextStyle(
                                fontFamily: 'Literal',
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter Number',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds:500 ),
                          margin: (gPay || phonePe)? EdgeInsets.only(left:15,right: 15,top:60): EdgeInsets.only(left:15,right: 15),
                          height: 63,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(14),bottomLeft: Radius.circular(14)),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:30.0,top:10,bottom: 10),
                                child: Image.asset('assets/images/phonepe.png'),
                              ),
                              Text('PhonePe',style: TextStyle(color: Colors.white,fontSize: 23,fontFamily: 'Literal',fontWeight: FontWeight.w200),),
                              Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Checkbox(
                                    value:phonePe,
                                    checkColor: Colors.white,
                                    focusColor: Colors.white,
                                    activeColor: Color(0xFF1F6A71),

                                    onChanged: (value) {
                                      setState(() {
                                        if(phonePe == false){
                                          gPay = false;
                                          upi = false;
                                          mode = 'PhonePe';
                                        }
                                        phonePe = !phonePe;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:35.0),
                      child: GestureDetector(
                        onTap:(){
                          if(allowed) {
                            setState(() {
                              payment = {
                                'Amount': payment['Amount'],
                                'GuidedStudents': payment['GuidedStudents'],
                                'status': 'Requested',
                                'UpiID':upiCtrl.text,
                                'Number':numCtrl.text,
                                'mode':mode,
                              };
                            });
                            setState(() {
                              allowed = false;
                            });
                            Firestore.instance.collection('helpers').document(emailID).updateData({'Payment': payment});
                          }else
                            print('Not allowed');},
                        child: Padding(
                          padding: const EdgeInsets.only(bottom:35.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: (allowed)?Theme.of(context).primaryColor:Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top:8.0,bottom: 8.0,left: 50,right: 50),
                              child: Text('Request Payment',style: TextStyle(color:Colors.white,fontSize: 25),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
              ),
          ),
        ),
      );
  }
}