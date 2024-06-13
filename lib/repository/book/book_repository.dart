import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/book_model.dart';
import '../../model/models.dart';
import 'base_book_repository.dart';

class BookRepository extends BaseBookRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  BookRepository();

  @override
  Future<List<Book>> getAllBooks() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('book')
          .where('status', isEqualTo: true).orderBy("update_at", descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Book().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Book>> getBookByCategory(String cateId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('book')
          .where('status', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .where((doc) => List<String>.from(doc.data()['categoryId']).contains(cateId))
          .map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Book().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Book>> getBookByLibrary(List<Library> libraries) async {
    try {
      List<String?> bookIds = libraries.map((library) => library.bookId).toList();

      var querySnapshot = await _firebaseFirestore
          .collection('book')
          .where('status', isEqualTo: true)
          .where(FieldPath.documentId, whereIn: bookIds)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Book().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Book> getBookById(String id) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('book').where(FieldPath.documentId, isEqualTo: id)
          .where('status', isEqualTo: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        return Book().fromJson(data);
      } else {
        // Trả về một giá trị mặc định nào đó hoặc null
        return Book();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}
