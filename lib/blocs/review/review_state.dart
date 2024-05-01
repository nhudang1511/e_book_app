part of 'review_bloc.dart';
abstract class ReviewState {
  const ReviewState();

}
class ReviewInitial extends ReviewState {
}
class ReviewLoading extends ReviewState{
}
class ReviewLoaded extends ReviewState{
  final List<Review> reviews;
  const ReviewLoaded({this.reviews = const <Review>[]});
}
class ReviewError extends ReviewState {
  final String error;

  const ReviewError(this.error);
}