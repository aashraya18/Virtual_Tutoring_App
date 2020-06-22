import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/services.dart';
import '../../../models/message_model.dart';
import '../../../models/advisor_model.dart';
import '../../../models/student_model.dart';
import './advisor_call_screen.dart';

class AdvisorChatScreen extends StatefulWidget {
  static const routeName = '/advisor-chat';
  @override
  _AdvisorChatScreenState createState() => _AdvisorChatScreenState();
}

class _AdvisorChatScreenState extends State<AdvisorChatScreen> {
  final messageTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime now;

  Future<void> _onSend() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    final sendTime = DateTime.now().toIso8601String();

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final Student student =
        ModalRoute.of(context).settings.arguments as Student;
    final Advisor advisor =
        Provider.of<AuthProvider>(context, listen: false).advisor;

    chatProvider.addAsAdvisor(
      message: messageTextController.text,
      studentUid: student.uid,
      advisorEmail: advisor.email,
      time: sendTime,
    );

    _formKey.currentState.reset();
    FocusScope.of(context).unfocus();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final student = ModalRoute.of(context).settings.arguments as Student;
    final Advisor advisor =
        Provider.of<AuthProvider>(context, listen: false).advisor;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            student.displayName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).canvasColor,
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await PermissionHandler().requestPermissions(
                  [PermissionGroup.camera, PermissionGroup.microphone],
                );
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdvisorCallScreen('${advisor.uid}' + '${student.uid}'),
                  ),
                );
              },
              icon: Icon(
                Icons.video_call,
                size: 35,
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Divider(),
            Expanded(child: MessageStrem()),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /* IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () {},
                    ), */
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Write your message...',
                        ),
                        controller: messageTextController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          messageTextController.text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).accentColor,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: _onSend,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class MessageStrem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final advisorMail = Provider.of<AuthProvider>(context).advisor.email;
    final student = ModalRoute.of(context).settings.arguments as Student;
    return StreamBuilder<List<Message>>(
        stream: Provider.of<ChatProvider>(context)
            .getAdvisorChat(student.uid, advisorMail),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.reversed.toList();
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) => MsgBox(
                text: messages[index].message,
                sender: messages[index].sender,
                time: messages[index].time,
                avatar: student.photoUrl,
              ),
              itemCount: messages.length,
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor));
          }
        });
  }
}

class MsgBox extends StatelessWidget {
  MsgBox({this.sender, this.text, this.time, this.avatar});
  final String sender;
  final String text;
  final String time;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: sender == 'advisor'
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border:
                  sender == 'student' ? Border.all(color: Colors.grey) : null,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5.0,
              color: sender == 'advisor'
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: sender == 'advisor'
                        ? Theme.of(context).accentColor
                        : Colors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child:
              Text(DateFormat('MMM d, ').add_jm().format(DateTime.parse(time)),
                  style: TextStyle(
                    color: Colors.grey,
                  )),
        )
      ],
    );
  }
}
