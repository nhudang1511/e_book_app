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
        .collection('review')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Review.fromSnapshot(doc)).toList();
    });
  }

}