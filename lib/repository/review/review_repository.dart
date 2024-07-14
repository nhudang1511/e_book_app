import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/models.dart';
import 'base_review_repository.dart';

class ReviewRepository extends BaseReviewRepository {
  final FirebaseFirestore _firebaseFirestore;

  ReviewRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Review>> getAllReview() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('review')
          .where('status', isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Review().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addBookInHistory(Review review) {
    return _firebaseFirestore.collection('review').add(review.toJson());
  }
}
