import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/author_model.dart';
import 'package:e_book_app/repository/author/base_author_repository.dart';

class AuthorRepository extends BaseAuthorRepository{

  final FirebaseFirestore _firebaseFirestore;
  AuthorRepository({FirebaseFirestore? firebaseFirestore})
      :_firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<List<Author>> getAllAuthors() {
    return _firebaseFirestore.collection('author').snapshots().map((snapshot){
      return snapshot.docs.map((doc) => Author.fromSnapshot(doc)).toList();
    });
  }

}