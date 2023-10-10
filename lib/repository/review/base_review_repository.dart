import '../../model/review_model.dart';
abstract class BaseReviewRepository{
  Stream<List<Review>> getAllReview();
}