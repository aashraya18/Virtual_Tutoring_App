import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'firestore_service.dart';
import '../models/advisor_model.dart';
import '../models/review_model.dart';
import '../models/student_model.dart';
import '../models/mentee_model.dart';

class StudentDatabaseProvider {
  final Student  student;
  StudentDatabaseProvider(this.student);
  final _service = FirestoreService.instance;
  final _storageService = FirebaseStorage.instance.ref();

  Stream<List<Advisor>> getFilteredAdvisors(String value) =>
      _service.collectionStreamWhere(
        path: 'helpers',
        field: 'categories',
        value: value,
        builder: (snapshot) => Advisor(
          about: snapshot.data['about'],
          branch: snapshot.data['branch'],
          college: snapshot.data['college'],
          displayName: snapshot.data['displayName'],
          email: '${snapshot.documentID}',
          menteesCount: snapshot.data['menteesCount'],
          phoneNumber: snapshot.data['phoneNumber'],
          photoUrl: snapshot.data['photoUrl'],
          rating: snapshot.data['rating'],
          reviewsCount: snapshot.data['reviewsCount'],
          uid: snapshot.data['uid'],
          payment: snapshot.data['payment'],
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

  Stream<List<String>> getMyAdvisorsList() => _service.collectionStream(
        path: 'students/${student.uid}/advisors',
        builder: (snapshot) => snapshot.documentID,
      );

  Future <List<dynamic>> getSlotTiming(String advisorEmail,String date) async{
    print(student.uid);
    try{
      final  document =  await _service.getData(docPath:'students/${student.uid}/advisors/$advisorEmail/slotBooking/$date');
      print(document['Booked']);
      return document['Booked'];
    }catch(e){
      print(e);
      return null;
    }
  }
  
 Future<dynamic> videoCallStatus(String advisorEmail , Map callStatus)async{
    try {
      print(callStatus);
      await _service.updateData(docPath: 'students/${student.uid}/advisors/$advisorEmail',
          data: {'videoCall': callStatus});
      var data = await _service.getData(docPath: 'students/${student.uid}/advisors/$advisorEmail');
      return data['videoCall'];
    }catch(e){
      print(e);
    }
  }

 Future<dynamic> videoCallStatus(String advisorEmail , Map callStatus)async{
    try {
      print(callStatus);
      await _service.updateData(docPath: 'students/${student.uid}/advisors/$advisorEmail',
          data: {'videoCall': callStatus});
      var data = await _service.getData(docPath: 'students/${student.uid}/advisors/$advisorEmail');
      return data['videoCall'];
    }catch(e){
      print(e);
    }
  }

  bookAdvisor(String advisorEmail) async{
    await _service.updateData(docPath: 'students/${student.uid}/advisors/$advisorEmail',  data:{'status':'done'});
  }

  Future<List<dynamic>> getStudentDeviceToken(String uid) async {
    final document = await _service.getData(docPath: 'students/$uid');
    return document['tokens'];
  }

  Future<Advisor> getMyAdvisor(String email) async {
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
    );
  }

  Stream<List<String>> getMyMessagesList() => _service.collectionStream(
        path: 'students/${student.uid}/messages',
        builder: (snapshot) => snapshot.documentID,
      );

//  Stream<List<String>> getMyBookedSlotList(advisorEmail) => _service.collectionStream(
//    path: 'students/${student.uid}/advisors/$advisorEmail/slotBooking',
//    builder: (snapshot) => snapshot.documentID,
//  );

  Future<Advisor> getMyMessages(String advisorEmail) async {
    final advisorData =
        await _service.getData(docPath: 'helpers/$advisorEmail');
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
    );
  }

  Future<void> addReview(String advisorEmail, Review review) async {
    try {
      final advisorData =
          await _service.getData(docPath: 'helpers/$advisorEmail');
      dynamic reviewCount = advisorData['reviewsCount'];
      dynamic rating = advisorData['rating'];
      dynamic totalRating = reviewCount * rating;
      reviewCount += 1;
      rating = (totalRating + review.stars) / reviewCount;
      await _service.updateData(docPath: 'helpers/$advisorEmail', data: {
        'reviewsCount': reviewCount,
        'rating': rating,
      });
      await _service.addData(collPath: 'helpers/$advisorEmail/reviews', data: {
        'heading': review.heading,
        'review': review.review,
        'stars': review.stars,
      });
    } catch (error) {
      throw error;
    }
  }


  Future<void> updateMyPhotoUrl(File file) async {
    final reference = _storageService.child('helpers/${student.uid}');
    final StorageUploadTask uploadTask = reference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    await _service.updateData(
        docPath: 'students/${student.uid}', data: {'photoUrl': url});
  }

  Future<void> updateMyProfile(
      String displayName, String bio, String email) async {
    await _service.updateData(docPath: 'students/${student.uid}', data: {
      'displayName': displayName,
      'bio': bio,
      'email': email,
    });
  }

}
