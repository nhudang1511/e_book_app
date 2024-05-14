part of 'review_bloc.dart';

abstract class ReviewEvent{
  const ReviewEvent();
}

class LoadedReview extends ReviewEvent {
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
}
