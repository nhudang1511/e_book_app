import 'package:e_book_app/model/custom_model.dart';
class Note extends CustomModel{
  final String? noteId;
  final String? title;
  final String? content;
  final String? uId;
  final String? bookId;

  Note({
   this.noteId,
   this.title,
   this.content,
   this.uId,
   this.bookId
  });
  
  @override
  Map<String, Object> toJson() {
    return {
      'title':title!,
      'content':content!,
      'uId':uId!,
      'bookId':bookId!
    };
  }

  @override
  Note fromJson(Map<String, dynamic> json) {
    Note note = Note(
      noteId: json['id'],
      title: json['title'],
      content: json['content'],
      uId: json['uId'],
      bookId: json['bookId']
    );
    return note;
  }
}