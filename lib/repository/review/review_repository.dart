import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/models.dart';
import 'base_review_repository.dart';

class ReviewRepository extends BaseReviewRepository{

  final FirebaseFirestore _firebaseFirestore;

  ReviewRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<List<Review>> getAllReview() {
    return _firebaseFirestore
        .collection('review').orderBy("time",descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Review.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> addBookInHistory(Review review) {
    return _firebaseFirestore.collection('review').add(review.toDocument());
  }

}