import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/library_model.dart';
import 'package:e_book_app/repository/library/base_library_repository.dart';

class LibraryRepository extends BaseLibraryRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  LibraryRepository();

  @override
  Future<void> addBookInLibrary(Library library) {
    return _firebaseFirestore.collection('libraries').add(library.toJson());
  }

  @override
  Future<List<Library>> getAllLibraries(String? userId) async {
    try {
      Query query = _firebaseFirestore.collection('libraries');

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      var querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
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
}
