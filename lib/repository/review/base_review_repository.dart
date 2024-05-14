import '../../model/review_model.dart';
abstract class BaseReviewRepository{
  Future<List<Review>> getAllReview();
  Future<void> addBookInHistory(Review review);
}