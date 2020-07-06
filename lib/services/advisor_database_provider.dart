import 'firestore_service.dart';

import '../models/advisor_model.dart';
import '../models/review_model.dart';
import '../models/student_model.dart';
import '../models/mentee_model.dart';

class AdvisorDatabaseProvider {
  final Advisor advisor;
  AdvisorDatabaseProvider(this.advisor);
  final _service = FirestoreService.instance;

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

  Future<List<dynamic>> getAdvisorDeviceToken(String emailId) async {
    final document = await _service.getData(docPath: 'helpers/$emailId');
    return document['tokens'];
  }
}
