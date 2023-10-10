part of 'review_bloc.dart';
abstract class ReviewEvent extends Equatable{
  const ReviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadedReview extends ReviewEvent{
  @override
  List<Object?> get props => [];
}
class UpdateReview extends ReviewEvent{
  final List<Review> reviews;
  const UpdateReview(this.reviews);
  @override
  List<Object?> get props => [reviews];
}