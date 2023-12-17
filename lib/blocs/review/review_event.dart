part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadedReview extends ReviewEvent {
  @override
  List<Object?> get props => [];
}

class UpdateReview extends ReviewEvent {
  final List<Review> reviews;

  const UpdateReview(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class AddNewReviewEvent extends ReviewEvent {
  final String bookId;
  final String content;
  final bool status;
  final String userId;
  final Timestamp time;
  final int rating;

  const AddNewReviewEvent(
      {required this.bookId,
      required this.content,
      required this.status,
      required this.userId,
      required this.time,
      required this.rating
      });

  @override
  List<Object?> get props => [bookId, content, status, userId, time];
}
