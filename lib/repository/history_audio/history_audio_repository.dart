import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/config/shared_preferences.dart';

import '../../model/models.dart';
import 'base_history_audio_repository.dart';

class HistoryAudioRepository extends BaseHistoryAudioRepository {
  final FirebaseFirestore _firebaseFirestore;

  HistoryAudioRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<HistoryAudio> addBookInHistoryAudio(HistoryAudio historyAudio) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('histories_audio')
          .where('uId', isEqualTo: historyAudio.uId)
          .where('bookId', isEqualTo: historyAudio.bookId)
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
          'percent': historyAudio.percent,
          'times': FieldValue.increment(1),
          'chapterScrollPositions': {
            ...existingChapterScrollPositions,
            ...?historyAudio.chapterScrollPositions,
          },
          'chapterScrollPercentages': {
            ...existingChapterScrollPercentages,
            ...?historyAudio.chapterScrollPercentages
          }
        };

        await doc.reference.update(updatedData);

        // Trả về lịch sử đã được cập nhật
        return HistoryAudio().fromJson(doc.data());
      } else {
        // Nếu không tồn tại, thêm một tài liệu mới với chapterScrollPositions mới
        var newDocRef =
            await _firebaseFirestore.collection('histories_audio').add({
          ...historyAudio.toJson(),
          'chapterScrollPositions': historyAudio.chapterScrollPositions,
          'chapterScrollPercentages': historyAudio.chapterScrollPercentages
        });

        // Lấy dữ liệu của tài liệu mới được thêm và trả về
        var newDocSnapshot = await newDocRef.get();
        return HistoryAudio().fromJson(newDocSnapshot.data()!);
      }
    } catch (e) {
      //print('Error adding book in historyAudio: $e');
      // Nếu có lỗi, trả về null hoặc xử lý theo ý định của bạn
      rethrow;
    }
  }

  @override
  Future<List<HistoryAudio>> getHistoryAudio(String bookId, String uId) async {
    if (bookId.isEmpty) {
      // Throw an error if the bookId parameter is empty.
      throw Exception("The bookId parameter cannot be empty.");
    }
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('histories_audio')
          .where('bookId', isEqualTo: bookId)
          .where('uId', isEqualTo: uId)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HistoryAudio().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<HistoryAudio>> getAllHistoryAudio() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('histories_audio')
          .where('uId', isEqualTo: SharedService.getUserId())
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HistoryAudio().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
