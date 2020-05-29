import './firestore_service.dart';
import '../models/advisor_model.dart';
import '../models/review_model.dart';
import '../models/student_model.dart';

abstract class DataBase {
  Stream<List<Advisor>> getHelpers();
}

class DatabaseProvider implements DataBase {
  final _service = FirestoreService.instance;

  Stream<List<Advisor>> getHelpers() => _service.collectionStream(
        path: 'helpers',
        builder: (snapshot) => Advisor(
          uid: snapshot.data['uid'],
          displayName: snapshot.data['displayName'],
          about: snapshot.data['about'],
          college: snapshot.data['college'],
          branch: snapshot.data['branch'],
          email: '${snapshot.documentID}',
          phoneNumber: snapshot.data['phoneNumber'],
          photoUrl: snapshot.data['photoUrl'],
        ),
      );

  Stream<List<Review>> getHelperReviews(String helperId) =>
      _service.collectionStream(
        path: 'helpers/$helperId/reviews',
        builder: (snapshot) => Review(
          heading: snapshot.data['heading'],
          review: snapshot.data['review'],
          stars: snapshot.data['stars'],
        ),
      );

  Stream<List<Student>> getHelperMentees(String helperId) =>
      _service.collectionStream(
        path: 'helpers/$helperId/mentees',
        builder: (snapshot) => Student(
          uid: snapshot.data['uid'],
          displayName: snapshot.data['fullName'],
          photoUrl: snapshot.data['imageUrl'],
          email: snapshot.data['email'],
        ),
      );
}
