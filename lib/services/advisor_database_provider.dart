
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'firestore_service.dart';

import '../models/advisor_model.dart';
import '../models/review_model.dart';
import '../models/student_model.dart';
import '../models/mentee_model.dart';

class AdvisorDatabaseProvider {
  final Advisor advisor;
  AdvisorDatabaseProvider(this.advisor);
  final _service = FirestoreService.instance;
  final _storageService = FirebaseStorage.instance.ref();

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
      rating: advisorData['rating'],
      reviewsCount: advisorData['reviewsCount'],
      uid: advisorData['uid'],
      payment: advisorData['payment'],
    );
  }


  Stream<List<String>> getAdvisorsList() => _service.collectionStream(
    path: 'helpers',
    builder: (snapshot) => snapshot.documentID,
  );

  Stream<List<Review>> getMyReviews() => _service.collectionStream(
        path: 'helpers/${advisor.email}/reviews',
        builder: (snapshot) => Review(
          heading: snapshot.data['heading'],
          review: snapshot.data['review'],
          stars: snapshot.data['stars'],
        ),
      );

  Stream<List<Mentee>> getMyMentees() => _service.collectionStream(
        path: 'helpers/${advisor.email}/mentees',
        builder: (snapshot) => Mentee(
          uid: snapshot.documentID,
          displayName: snapshot['displayName'],
          status: snapshot['status'],
        ),
      );

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

  Future <List<dynamic>> getSlotTiming(String advisorEmail,String date) async{
    //print(student.uid);
    try{
      final  document =  await _service.getData(docPath:'helpers/$advisorEmail/freeSlots/$date');
      print(document['Booked']);
      return document['Booked'];
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<dynamic> getAdvisorDetails(String emailId , String field) async {
    final document = await _service.getData(docPath: 'helpers/$emailId');
    return document['$field'];
  }

  Future<void> updateMyPhotoUrl(File file) async {
    final reference = _storageService.child('student/${advisor.uid}');
    final StorageUploadTask uploadTask = reference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    await _service.updateData(
        docPath: 'helpers/${advisor.email}', data: {'photoUrl': url});
  }

  Future<void> updateMyProfile(
      String displayName, String bio, String email , String contacts) async {
    await _service.updateData(docPath: 'helpers/${advisor.email}', data: {
      'displayName': displayName,
      'about': bio,
      'email': email,
      'phoneNumber' : contacts,
    });
  }
}
