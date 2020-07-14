import 'package:flutter/cupertino.dart';

import 'firestore_service.dart';
import '../models/message_model.dart';

class ChatProvider {
  final _firestoreService = FirestoreService.instance;

  Future<void> addAsStudent({
    @required String message,
    @required String studentUid,
    @required String advisorEmail,
    @required String time,
  }) async {
    await _firestoreService.updateData(
      docPath: 'students/$studentUid/messages/$advisorEmail',
      data: {'status': 'on'},
    );
    await _firestoreService.updateData(
      docPath: 'helpers/$advisorEmail/messages/$studentUid',
      data: {'status': 'on'},
    );
    await _firestoreService.updateData(
      docPath: 'students/$studentUid/messages/$advisorEmail/chat/$time',
      data: {
        'message': message,
        'sender': 'student',
      },
    );
    await _firestoreService.updateData(
      docPath: 'helpers/$advisorEmail/messages/$studentUid/chat/$time',
      data: {
        'message': message,
        'sender': 'student',
      },
    );
  }

  Future<void> addAsAdvisor({
    @required String message,
    @required String studentUid,
    @required String advisorEmail,
    @required String time,
  }) async {
    await _firestoreService.updateData(
      docPath: 'students/$studentUid/messages/$advisorEmail',
      data: {'status': 'on'},
    );
    await _firestoreService.updateData(
      docPath: 'helpers/$advisorEmail/messages/$studentUid',
      data: {'status': 'on'},
    );
    await _firestoreService.updateData(
      docPath: 'students/$studentUid/messages/$advisorEmail/chat/$time',
      data: {
        'message': message,
        'sender': 'advisor',
      },
    );
    await _firestoreService.updateData(
      docPath: 'helpers/$advisorEmail/messages/$studentUid/chat/$time',
      data: {
        'message': message,
        'sender': 'advisor',
      },
    );
  }

  Stream<List<Message>> getStudentChat(
          String studentUid, String advisorEmail) =>
      _firestoreService.collectionStream(
        path: 'students/$studentUid/messages/$advisorEmail/chat',
        builder: (snapshot) => Message(
          message: snapshot['message'],
          sender: snapshot['sender'],
          time: snapshot.documentID,
        ),
      );

  Stream<List<Message>> getAdvisorChat(
          String studentUid, String advisorEmail) =>
      _firestoreService.collectionStream(
        path: 'helpers/$advisorEmail/messages/$studentUid/chat',
        builder: (snapshot) => Message(
          message: snapshot['message'],
          sender: snapshot['sender'],
          time: snapshot.documentID,
        ),
      );
}
