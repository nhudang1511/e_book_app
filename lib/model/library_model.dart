import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Library extends Equatable {
  final String bookId;
  final String userId;

  const Library({required this.bookId, required this.userId});
  @override
  List<Object?> get props => [bookId,userId];

  Map<String, Object> toDocument(){
    return {
      'bookId': bookId,
      'userId': userId
    };
  }
  static Library fromSnapshot(DocumentSnapshot snap) {
    Library library = Library(
        bookId: snap['bookId'],
        userId: snap['userId']
    );
    return library;
  }
}