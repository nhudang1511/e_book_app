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
            ...history.chapterScrollPositions,
          },
          'chapterScrollPercentages': {
            ...existingChapterScrollPercentages,
            ...history.chapterScrollPercentages
          }
        };

        await doc.reference.update(updatedData);
      } else {
        // Nếu không tồn tại, thêm một tài liệu mới với chapterScrollPositions mới
        await _firebaseFirestore.collection('histories').add({
          ...history.toDocument(),
          'chapterScrollPositions': history.chapterScrollPositions,
          'chapterScrollPercentages': history.chapterScrollPercentages
        });
      }
    } catch (e) {
      //print('Error adding book in history: $e');
    }
  }

  @override
  Stream<List<History>> getAllHistories() {
    return _firebaseFirestore
        .collection('histories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => History.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<History> getHistories(String bookId) {
    if (bookId.isEmpty) {
      // Throw an error if the bookId parameter is empty.
      throw Exception("The bookId parameter cannot be empty.");
    }
    return _firebaseFirestore
        .collection('histories')
        .where('chapters', isEqualTo: bookId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return History.fromSnapshot(snapshot.docs.first);
      } else {
        // If no documents are found, return a default or handle it as needed.
        // Here, returning an empty History object for illustration.
        return const History(
            uId: '',
            chapters: '',
            percent: 0.0,
            times: 0,
            chapterScrollPositions: {},
            chapterScrollPercentages: {}); // Replace with appropriate handling.
      }
    });
  }
}
