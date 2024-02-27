import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/book_model.dart';
import 'base_book_repository.dart';

class BookRepository extends BaseBookRepository{

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //final BookRepository _bookRepository;
  BookRepository();
  @override
  Future<List<Book>> getAllBooks() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('book').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Book.fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}