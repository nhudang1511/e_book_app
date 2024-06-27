import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/repository/library/base_library_repository.dart';

import '../../config/shared_preferences.dart';
import '../../model/models.dart';

class LibraryRepository extends BaseLibraryRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  LibraryRepository();

  @override
  Future<void> addBookInLibrary(Library library) {
    return _firebaseFirestore.collection('libraries').add(library.toJson());
  }

  @override
  Future<List<Library>> getAllLibraries() async {
    try {
      var querySnapshot =
          await _firebaseFirestore.collection('libraries').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Library().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeBookInLibrary(Library library) {
    return _firebaseFirestore
        .collection('libraries')
        .where('bookId', isEqualTo: library.bookId)
        .where('userId', isEqualTo: library.userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<List<Library>> getAllLibrariesByUid(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('libraries')
          .where('userId', isEqualTo: uId)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Library().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<(List<Book>, DocumentSnapshot<Object?>?)> readBooksByLibrary(
      {int limit = 5,
        DocumentSnapshot<Object?>? startAfterDoc}) async {
    try {
      // 1) Query for documents with a limit.
      var query = _firebaseFirestore
          .collection("book")
          .where('status', isEqualTo: true)
          .orderBy("update_at", descending: true)
          .limit(limit);

      // 2) If paginating, then use the passed
      //    in document as the query cursor.
      final querySnapshot = startAfterDoc != null
          ? await query.startAfterDocument(startAfterDoc).get()
          : await query.get();

      // 3) If the number of fetched documents is equal to our limit,
      //    then we define the last document as the query cursor.
      final finalDoc =
      querySnapshot.docs.length == limit ? querySnapshot.docs.last : null;

      // 4) Return the fetched documents and query cursor.
      List<Book> books = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        //await fetchAuthorAndCategoryNames(data);

        // Check if this category is referenced by any book
        var libraryQuery = await _firebaseFirestore
            .collection('libraries')
            .where('bookId', isEqualTo: data['id'])
            .where('userId', isEqualTo: SharedService.getUserId())
            .get();

        if (libraryQuery.docs.isNotEmpty) {
          books.add(Book().fromJson(data));
        }
      }

      return (books, finalDoc);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
