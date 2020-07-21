import 'dart:async';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:android/services/advisor_database_provider.dart';
import 'package:android/services/student_database_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:android/google_sheet/call_log.dart';
import 'package:android/google_sheet/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android/services/auth_provider.dart';
import 'package:android/models/student_model.dart';
class AdvisorCallScreen extends StatefulWidget {
  final String channelName;
  const AdvisorCallScreen(this.channelName);

  @override
  _AdvisorCallScreenState createState() => _AdvisorCallScreenState();
}

class _AdvisorCallScreenState extends State<AdvisorCallScreen> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  Map payment;
  int amount;
  int guidedStudents;
  Student student;

  logToExcel(String event) async{
    final now = DateTime.now();
    FirebaseUser email = await FirebaseAuth.instance.currentUser();
    String emailID = email.email;
   var  name = await Provider.of<AdvisorDatabaseProvider>(context ,listen:false).getAdvisorDetails(emailID, 'displayName');
    VideoCallLog callLog = VideoCallLog(name, now.toString(),event,'Advisor');
    LogController logController = LogController((String response){
      print("Response: $response");

    });
    logController.submitForm(callLog);
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  creditToAdvisor(){
    amount =  payment['Amount'] +100;
    guidedStudents = payment['GuidedStudents']+1;
    String status = "";
    if(amount >= 2000)
      setState(() {
        status = 'allowed';
      });
    payment = {
      'Amount': amount,
      'GuidedStudents':guidedStudents,
      'status':status,
    };

    print(payment);
    Firestore.instance.collection('helpers').document('test@advisor.com').updateData({'Payment':payment});

  }

  createAlertDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
         return AlertDialog(
           title: Text('Was your call successful.You will not be able to enter the call again',style: TextStyle(color:Colors.white),),
           backgroundColor: Theme.of(context).primaryColor,
           actions: [
             FlatButton(

               child: Text('Yes'),
               onPressed: () async{
                 print('yes');
                 print(student.email);
                 StudentDatabaseProvider instance = StudentDatabaseProvider(student);
                 Map videoCallStatus ={
                   'Student':'Yes',
                 };
                 Map data = await instance.videoCallStatus('test@advisor.com',videoCallStatus);
                 print(data);
                 if(data['Advisor'] == 'Yes')
                   creditToAdvisor();
                 Navigator.pop(context);
                 _onCallEnd(context);
               },
             ),

             FlatButton(

               child: Text('No'),
               onPressed: (){
                 print('no');
               },
             ),
           ],
         );
        }
    );
  }

  int counter = 1620;
  Timer _timer;
  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1),(timer){
      setState(() {
        //print(counter);
        counter--;
      });

      if(counter == 1320)
        logToExcel('5 mins in call');
      else if(counter == 720)
        logToExcel('15 mins in call');

      if(counter == 0){
        _timer.cancel();
        _onCallEnd(context);
      }
    });
  }


  getPayment() async{
    FirebaseUser email = await FirebaseAuth.instance.currentUser();
    String emailID = email.email;
    payment = await Provider.of<AdvisorDatabaseProvider>(context ,listen:false).getAdvisorDetails(emailID, 'Payment');
    if(payment == null){
      payment ={
        'Amount':0,
        'GuidedStudents':0,
      };
      print(payment);
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    _startTimer();
    getPayment();
    initialize();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create('54edcd3ad0fd4c12b043cc3e8cd465b1');
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [];
    list.add(AgoraRenderWidget(0, local: true, preview: true));
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () async{
             await createAlertDialog(context);
              _onCallEnd(context);
              },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  /* Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  } */

  void _onCallEnd(BuildContext context) {
    logToExcel('End');
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {

    student = Provider.of<AuthProvider>(context, listen: false).student;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            // _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
