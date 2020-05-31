import './firestore_service.dart';
import '../models/advisor_model.dart';
import '../models/review_model.dart';
import '../models/student_model.dart';

abstract class DataBase {
  Stream<List<Advisor>> getAdvisors();
  Stream<List<Review>> getAdvisorReviews(String advisorEmail);
  Stream<List<Student>> getAdvisorMentees(String advisorEmail);
}

class DatabaseProvider implements DataBase {
  final _service = FirestoreService.instance;

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

  Stream<List<Student>> getAdvisorMentees(String advisorEmail) =>
      _service.collectionStream(
        path: 'helpers/$advisorEmail/mentees',
        builder: (snapshot) => Student(
          uid: snapshot.data['uid'],
          displayName: snapshot.data['fullName'],
          photoUrl: snapshot.data['imageUrl'],
          email: snapshot.data['email'],
        ),
      );
}
