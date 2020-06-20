import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import './firestore_service.dart';
import '../models/advisor_model.dart';
import '../models/review_model.dart';
import '../models/student_model.dart';
import '../models/mentee_model.dart';

class DatabaseProvider {
  final Student student;
  DatabaseProvider(this.student);
  final _service = FirestoreService.instance;
  final _storageService = FirebaseStorage.instance.ref();

  Stream<List<Advisor>> getAdvisors() => _service.collectionStream(
        path: 'helpers',
        builder: (snapshot) => Advisor(
          about: snapshot.data['about'],
          branch: snapshot.data['branch'],
          college: snapshot.data['college'],
          displayName: snapshot.data['displayName'],
          email: '${snapshot.documentID}',
          menteesCount: snapshot.data['menteesCount'],
          phoneNumber: snapshot.data['phoneNumber'],
          photoUrl: snapshot.data['photoUrl'],
          reviewsCount: snapshot.data['reviewsCount'],
          uid: snapshot.data['uid'],
        ),
      );

  Stream<List<Review>> getAdvisorReviews(String advisorEmail) =>
      _service.collectionStream(
        path: 'helpers/$advisorEmail/reviews',
        builder: (snapshot) => Review(
          heading: snapshot.data['heading'],
          review: snapshot.data['review'],
          stars: snapshot.data['stars'],
        ),
      );

  Stream<List<Mentee>> getAdvisorMentees(String advisorEmail) =>
      _service.collectionStream(
        path: 'helpers/$advisorEmail/mentees',
        builder: (snapshot) => Mentee(
          uid: snapshot.documentID,
          displayName: snapshot['displayName'],
          status: snapshot['status'],
        ),
      );
  Stream<List<String>> getMyAdvisors() => _service.collectionStream(
        path: 'students/${student.uid}/advisors',
        builder: (snapshot) => snapshot.documentID,
      );

  Future<Advisor> getAdvisor(String email) async {
    final advisorData = await _service.getData(docPath: 'helpers/$email');
    return Advisor(
      about: advisorData['about'],
      branch: advisorData['branch'],
      college: advisorData['college'],
      displayName: advisorData['displayName'],
      email: '${advisorData.documentID}',
      menteesCount: advisorData['menteesCount'],
      phoneNumber: advisorData['phoneNumber'],
      photoUrl: advisorData['photoUrl'],
      reviewsCount: advisorData['reviewsCount'],
      uid: advisorData['uid'],
    );
  }

  Stream<List<String>> getMyMessagesAdvisors() => _service.collectionStream(
        path: 'students/${student.uid}/messages',
        builder: (snapshot) => snapshot.documentID,
      );

  Future<Advisor> getMessageAdvisor(String email) async {
    final advisorData = await _service.getData(docPath: 'helpers/$email');
    return Advisor(
      about: advisorData['about'],
      branch: advisorData['branch'],
      college: advisorData['college'],
      displayName: advisorData['displayName'],
      email: '${advisorData.documentID}',
      menteesCount: advisorData['menteesCount'],
      phoneNumber: advisorData['phoneNumber'],
      photoUrl: advisorData['photoUrl'],
      reviewsCount: advisorData['reviewsCount'],
      uid: advisorData['uid'],
    );
  }

  Future<void> addToMyAdvisors(String advisorEmail) async =>
      await _service.updateData(
          docPath: 'students/${student.uid}/advisors/$advisorEmail',
          data: {'status': 'done'});

  Future<void> addToMyStudents(String advisorEmail) async {
    await _service.updateData(
        docPath: 'helpers/$advisorEmail/mentees/${student.uid}',
        data: {'status': 'done', 'displayName': student.displayName});
    final data = await _service.getData(docPath: 'helpers/$advisorEmail');
    int menteesCount = int.parse(data.data['menteesCount']);
    menteesCount += 1;

    await _service.updateData(
        docPath: 'helpers/$advisorEmail',
        data: {'menteesCount': menteesCount.toString()});
  }

  Future<Student> getStudent(String uid) async {
    final document = await _service.getData(docPath: 'students/$uid');
    return Student(
      bio: document['bio'],
      displayName: document['displayName'],
      email: document['email'],
      phoneNumber: document['phoneNumber'],
      photoUrl: document['photoUrl'],
      uid: document.documentID,
    );
  }

  Future<void> updatePhotoUrl(File file) async {
    final reference = _storageService.child('helpers/${student.uid}');
    final StorageUploadTask uploadTask = reference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    await _service.updateData(
        docPath: 'students/${student.uid}', data: {'photoUrl': url});
  }

  Future<void> updateProfile(
      String displayName, String bio, String email) async {
    await _service.updateData(docPath: 'students/${student.uid}', data: {
      'displayName': displayName,
      'bio': bio,
      'email': email,
    });
  }
}
