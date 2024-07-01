import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
import 'base_question_repository.dart';

class QuestionRepository extends BaseQuestionRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  QuestionRepository();

  @override
  Future<List<Question>> getAllQuestion() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('questions')
          .where('status', isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Question().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
