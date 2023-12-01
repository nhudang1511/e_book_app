import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String bookId;
  final String content;
  final bool status;
  final String userId;
  final Timestamp time;

  const Review(
      {required this.bookId,
      required this.content,
      required this.status,
      required this.userId,
      required this.time});

  @override
  List<Object?> get props => [bookId, content, status, userId, time];

  static Review fromSnapshot(DocumentSnapshot snap) {
    Review review = Review(
        bookId: snap['bookId'],
        content: snap['content'],
        status: snap['status'],
        userId: snap['userId'],
        time: snap['time']);
    return review;
  }
  Map<String, Object> toDocument() {
    return {
      'bookId': bookId,
      'content': content,
      'status': status,
      'userId': userId,
      'time': time
    };
  }
}
