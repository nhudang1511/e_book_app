import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import 'base_chapters_repository.dart';

class ChaptersRepository extends BaseChaptersRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ChaptersRepository();

  @override
  Future<Chapters> getChapters(String bookId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('chapters')
          .where('bookId', isEqualTo: bookId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        return Chapters().fromJson(data);
      } else {
        // Trả về một giá trị mặc định nào đó hoặc null
        return Chapters(); // Hoặc trả về một đối tượng Chapters mặc định
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
