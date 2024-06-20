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
          .where('status', isEqualTo: true)
          .orderBy("update_at", descending: true)
          .get();

      List<Book> books = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;

        // Fetch the author data synchronously
        var authorDoc = await _firebaseFirestore
            .collection('author')
            .doc(data['authodId'])
            .get();

        if (authorDoc.exists) {
          data['authorName'] = authorDoc.get('fullName');
        } else {
          data['authorName'] = 'Unknown Author'; // Handle the case when the author document does not exist
        }

        // Fetch category names
        List<String> categoryNames = [];
        if (data['categoryId'] != null && data['categoryId'] is List) {
          for (String categoryId in List<String>.from(data['categoryId'])) {
            var cateDoc = await _firebaseFirestore
                .collection('category')
                .doc(categoryId)
                .get();
            if (cateDoc.exists) {
              categoryNames.add(cateDoc.get('name'));
            }
          }
        }
        data['categoryName'] = categoryNames;

        books.add(Book().fromJson(data));
      }

      return books;
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

      List<Book> books = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();

        // Check if the book belongs to the given category
        if (List<String>.from(data['categoryId']).contains(cateId)) {
          data['id'] = doc.id;

          // Fetch the author data synchronously
          var authorDoc = await _firebaseFirestore
              .collection('author')
              .doc(data['authodId'])
              .get();

          if (authorDoc.exists) {
            data['authorName'] = authorDoc.get('fullName');
          } else {
            data['authorName'] =
                'Unknown Author'; // Handle the case when the author document does not exist
          }
          List<String> categoryNames = [];
          if (data['categoryId'] != null && data['categoryId'] is List) {
            for (String categoryId in List<String>.from(data['categoryId'])) {
              var cateDoc = await _firebaseFirestore
                  .collection('category')
                  .doc(categoryId)
                  .get();
              if (cateDoc.exists) {
                categoryNames.add(cateDoc.get('name'));
              }
            }
          }
          data['categoryName'] = categoryNames;
          books.add(Book().fromJson(data));
        }
      }

      return books;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
