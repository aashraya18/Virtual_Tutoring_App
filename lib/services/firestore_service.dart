import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _instance = Firestore.instance;

  Future<DocumentReference> addData({
    @required String collPath,
    @required Map<String, dynamic> data,
  }) async {
    final document = await _instance.collection(collPath).add(data);
    return document;
  }

  Future<void> setData({
    @required String docPath,
    @required Map<String, dynamic> data,
  }) async {
    final reference = _instance.document(docPath);
    await reference.setData(data);
  }

  Future<void> updateData({
    @required String docPath,
    @required Map<String, dynamic> data,
  }) async {
    final reference = _instance.document(docPath);
    await reference.setData(data, merge: true);
  }

  Future<DocumentSnapshot> getData({
    @required String docPath,
  }) async {
    final document = await _instance.document(docPath).get();
    return document;
  }

  Future<void> deleteDocument({
    @required String documentPath,
  }) async {
    await _instance.document(documentPath).delete();
  }

  Future<QuerySnapshot> getDocuments({
    @required String collectionPath,
  }) async {
    final snapshot = await _instance.collection(collectionPath).getDocuments();
    return snapshot;
  }

  Stream<List<T>> collectionStreamWhere<T>({
    @required String path,
    @required T builder(DocumentSnapshot data),
    @required String field,
    @required String value,
  }) {
    Query reference = _instance.collection(path).where(field, isEqualTo: value);

    return collectionStreamBase(reference: reference, builder: builder);
  }

  Stream<List<T>> collectionStreamOrderBy<T>({
    @required String path,
    @required T builder(DocumentSnapshot data),
    @required String orderBy,
  }) {
    Query reference = _instance.collection(path).orderBy(orderBy);

    return collectionStreamBase(reference: reference, builder: builder);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(DocumentSnapshot data),
  }) {
    Query reference = _instance.collection(path);
    return collectionStreamBase(reference: reference, builder: builder);
  }

  Stream<List<T>> collectionStreamBase<T>({
    @required Query reference,
    @required T builder(DocumentSnapshot data),
  }) {
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.documents.map((snapshot) => builder(snapshot)).toList());
  }
}
