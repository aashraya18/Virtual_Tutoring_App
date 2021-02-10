import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scratcher/scratcher.dart';

class Referral extends StatefulWidget {
  static const routeName = '/referral';
  @override
  _ReferralState createState() => _ReferralState();
}

class _ReferralState extends State<Referral> {
  int vorbyCoins = 20;
  String referralCode = 'CSGVJHS';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Icon(MdiIcons.alphaVCircle,
            color: Theme.of(context).primaryColor,
            size: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 20.0,top: 13.0),
            child: Text(
              '$vorbyCoins',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20.0
              ),
            ),
          )
        ],

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Invite your friends using the referral code and earn vorby coins\nScratch and Win',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
                child: Scratcher(
                  brushSize: 30,
                  threshold: 50,
                  color: Colors.red,
                  onChange: (value) { print("Scratch progress: $value%"); },
                  onThreshold: () { print("Threshold reached, you won!"); },
                  child: Container(
                    height: 300,
                    width: 300,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Your Referral Code',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      padding: const EdgeInsets.only(top: 10.0,bottom: 10.0, left: 20.0,right: 100.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Text("$referralCode",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0
                      ),),
                    ),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}
