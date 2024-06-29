import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import 'base_audio_repository.dart';

class AudioRepository extends BaseAudioRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AudioRepository();

  @override
  Future<Audio> getChaptersAudio(String bookId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('audio')
          .where('bookId', isEqualTo: bookId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        data['id'] = querySnapshot.docs.first.id;
        return Audio().fromJson(data);
      } else {
        // Trả về một giá trị mặc định nào đó hoặc null
        return Audio(); // Hoặc trả về một đối tượng Audio mặc định
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
