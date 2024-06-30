import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import 'base_chapters_repository.dart';

class ChaptersRepository extends BaseChaptersRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ChaptersRepository();

  @override
  Future<Chapters?> getChapters(String bookId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('chapters')
          .where('bookId', isEqualTo: bookId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        data['id'] = querySnapshot.docs.first.id;
        return Chapters().fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
