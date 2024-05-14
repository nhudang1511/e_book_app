import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/custom_model.dart';
import 'package:equatable/equatable.dart';

class Review extends CustomModel {
  final String? bookId;
  final String? content;
  final bool? status;
  final String? userId;
  final Timestamp? time;
  final int? rating;

  Review(
      {this.bookId,
      this.content,
      this.status,
      this.userId,
      this.time,
      this.rating
      });
  
  @override
  Review fromJson(Map<String, dynamic> json) {
    Review review = Review(
        bookId: json['bookId'],
        content: json['content'],
        status: json['status'],
        userId: json['userId'],
        time: json['time'],
      rating: json['rating']
    );
    return review;
  }

  @override
  Map<String, Object> toJson() {
    return {
      'bookId': bookId!,
      'content': content!,
      'status': status!,
      'userId': userId!,
      'time': time!,
      'rating': rating!
    };
  }
}
