import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
import 'base_history_repository.dart';

class HistoryRepository extends BaseHistoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  HistoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  // @override
  // Future<void> addBookInHistory(History history) {
  //   return _firebaseFirestore.collection('histories').add(history.toDocument());
  // }
  @override
  Future<void> addBookInHistory(History history) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('histories')
          .where('uId', isEqualTo: history.uId)
          .where('chapters', isEqualTo: history.chapters)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var existingData = doc.data();

        // Lấy giá trị chapterScrollPositions từ Firebase
        var existingChapterScrollPositions =
            existingData['chapterScrollPositions'] as Map<String, dynamic>;
        var existingChapterScrollPercentages =
            existingData['chapterScrollPercentages'] as Map<String, dynamic>;
        // Cập nhật giá trị chapterScrollPositions, times và percent mới
        var updatedData = {
          'percent': history.percent,
          'times': FieldValue.increment(1),
          'chapterScrollPositions': {
            ...existingChapterScrollPositions,
            ...?history.chapterScrollPositions,
          },
          'chapterScrollPercentages': {
            ...existingChapterScrollPercentages,
            ...?history.chapterScrollPercentages
          }
        };

        await doc.reference.update(updatedData);
      } else {
        // Nếu không tồn tại, thêm một tài liệu mới với chapterScrollPositions mới
        await _firebaseFirestore.collection('histories').add({
          ...history.toJson(),
          'chapterScrollPositions': history.chapterScrollPositions,
          'chapterScrollPercentages': history.chapterScrollPercentages
        });
      }
    } catch (e) {
      //print('Error adding book in history: $e');
    }
  }

  @override
  Future<List<History>> getAllHistories() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('histories').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return History().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<History> getHistories(String bookId, String uId) async {
    if (bookId.isEmpty) {
      // Throw an error if the bookId parameter is empty.
      throw Exception("The bookId parameter cannot be empty.");
    }
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('histories')
          .where('chapters', isEqualTo: bookId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        return History().fromJson(data);
      } else {
        // Trả về một giá trị mặc định nào đó hoặc null
        return History(); // Hoặc trả về một đối tượng Chapters mặc định
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
