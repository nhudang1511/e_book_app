import 'package:e_book_app/model/custom_model.dart';

class Library extends CustomModel {
  final String? bookId;
  final String? userId;

  Library({this.bookId, this.userId});

  @override
  Map<String, Object> toJson(){
    return {
      'bookId': bookId!,
      'userId': userId!
    };
  }
  @override
  Library fromJson(Map<String, dynamic> json) {
    Library library = Library(
        bookId: json['bookId'],
        userId: json['userId']
    );
    return library;
  }
}