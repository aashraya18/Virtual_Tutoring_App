import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/services.dart';
import '../../../models/message_model.dart';
import '../../../models/advisor_model.dart';
import './student_call_screen.dart';

class StudentChatScreen extends StatefulWidget {
  static const routeName = '/student-chat';
  @override
  _StudentChatScreenState createState() => _StudentChatScreenState();
}

class _StudentChatScreenState extends State<StudentChatScreen> {
  final messageTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime now;

  Future<void> _onSend() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    final sendTime = DateTime.now().toIso8601String();

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final studentUid =
        Provider.of<AuthProvider>(context, listen: false).student.uid;
    final advisor = ModalRoute.of(context).settings.arguments as Advisor;

    chatProvider.addAsStudent(
      message: messageTextController.text,
      studentUid: studentUid,
      advisorEmail: advisor.email,
      time: sendTime,
    );

    _formKey.currentState.reset();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<AuthProvider>(context, listen: false).student;
    final advisor = ModalRoute.of(context).settings.arguments as Advisor;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            advisor.displayName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
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
                        StudentCallScreen('${advisor.uid}' + '${student.uid}'),
                  ),
                );
              },
              icon: Icon(
                Icons.video_call,
                size: 40,
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Divider(),
            Expanded(child: MessageStream()),
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

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentUid = Provider.of<AuthProvider>(context).student.uid;
    final advisor = ModalRoute.of(context).settings.arguments as Advisor;
    return StreamBuilder<List<Message>>(
        stream: Provider.of<ChatProvider>(context)
            .getStudentChat(studentUid, advisor.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.reversed.toList();
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) => MessageBox(
                text: messages[index].message,
                sender: messages[index].sender,
                time: messages[index].time,
                avatar: advisor.photoUrl,
              ),
              itemCount: messages.length,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class MessageBox extends StatelessWidget {
  MessageBox({this.sender, this.text, this.time, this.avatar});
  final String sender;
  final String text;
  final String time;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: sender == 'student'
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border:
                  sender == 'advisor' ? Border.all(color: Colors.grey) : null,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: sender == 'student'
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: sender == 'student'
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
