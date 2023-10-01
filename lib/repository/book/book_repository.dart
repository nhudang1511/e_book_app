import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/book_model.dart';
import 'base_book_repository.dart';

class BookRepository extends BaseBookRepository{

  final FirebaseFirestore _firebaseFirestore;

  BookRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<List<Book>> getAllBooks() {
    return _firebaseFirestore
        .collection('book')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromSnapshot(doc)).toList();
    });
  }

}