import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import 'base_history_repository.dart';

class HistoryRepository extends BaseHistoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  HistoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<History> addBookInHistory(History history) async {
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

        // Trả về lịch sử đã được cập nhật
        return History().fromJson(doc.data());
      } else {
        // Nếu không tồn tại, thêm một tài liệu mới với chapterScrollPositions mới
        var newDocRef = await _firebaseFirestore.collection('histories').add({
          ...history.toJson(),
          'chapterScrollPositions': history.chapterScrollPositions,
          'chapterScrollPercentages': history.chapterScrollPercentages
        });

        // Lấy dữ liệu của tài liệu mới được thêm và trả về
        var newDocSnapshot = await newDocRef.get();
        return History().fromJson(newDocSnapshot.data()!);
      }
    } catch (e) {
      //print('Error adding book in history: $e');
      // Nếu có lỗi, trả về null hoặc xử lý theo ý định của bạn
      rethrow;
    }
  }

  @override
  Future<List<History>> getHistories(String bookId, String uId) async {
    if (bookId.isEmpty) {
      // Throw an error if the bookId parameter is empty.
      throw Exception("The bookId parameter cannot be empty.");
    }
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('histories')
          .where('chapters', isEqualTo: bookId)
          .where('uId', isEqualTo: uId)
          .get();
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
  Future<History> getHistoryByUId(String uId, String bookId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('histories')
          .where('uId', isEqualTo: uId)
          .where('chapters', isEqualTo: bookId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        data['id'] = querySnapshot.docs.first.id;
        return History().fromJson(data);
      } else {
        return History();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot> streamHistories(String uId) {
    return _firebaseFirestore
        .collection('histories')
        .where('uId', isEqualTo: uId)
        .snapshots();
  }

  @override
  Future<History> removeItemInHistory(History history) async {
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
        var existingChapterScrollPositions = existingData['chapterScrollPositions'] as Map<String, dynamic>;
        var existingChapterScrollPercentages = existingData['chapterScrollPercentages'] as Map<String, dynamic>;

        // Xóa các item nếu key tồn tại
        var updatedChapterScrollPositions = _removeMatchingKeys(existingChapterScrollPositions, history.chapterScrollPositions);
        var updatedChapterScrollPercentages = _removeMatchingKeys(existingChapterScrollPercentages, history.chapterScrollPercentages);

        // Cập nhật giá trị chapterScrollPositions, times và percent mới
        var updatedData = {
          'percent': history.percent,
          'times': FieldValue.increment(1),
          'chapterScrollPositions': updatedChapterScrollPositions,
          'chapterScrollPercentages': updatedChapterScrollPercentages,
        };

        await doc.reference.update(updatedData);

        // Trả về lịch sử đã được cập nhật
        return History().fromJson(doc.data());
      } else {
        // Nếu không tồn tại, thêm một tài liệu mới với chapterScrollPositions mới
        var newDocRef = await _firebaseFirestore.collection('histories_audio').add({
          ...history.toJson(),
          'chapterScrollPositions': history.chapterScrollPositions,
          'chapterScrollPercentages': history.chapterScrollPercentages
        });

        // Lấy dữ liệu của tài liệu mới được thêm và trả về
        var newDocSnapshot = await newDocRef.get();
        return History().fromJson(newDocSnapshot.data()!);
      }
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _removeMatchingKeys(Map<String, dynamic> map, Map<String, dynamic>? keysToKeep) {
    if (keysToKeep == null) return {};
    var updatedMap = Map<String, dynamic>.from(map);
    updatedMap.removeWhere((key, value) => !keysToKeep.containsKey(key));
    return updatedMap;
  }
}
