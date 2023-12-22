import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Note extends Equatable{
  final String noteId;
  final String title;
  final String content;
  final String uId;
  final String bookId;

  const Note({
    required this.noteId,
    required this.title,
    required this.content,
    required this.uId,
    required this.bookId
  });

  @override
  List<Object?> get props =>[title,content,uId,bookId,noteId];
  Map<String, Object> toDocument() {
    return {
      'title':title,
      'content':content,
      'uId':uId,
      'bookId':bookId
    };
  }

  static Note fromSnapshot(DocumentSnapshot snap) {
    Note note = Note(
      noteId: snap.id,
      title: snap['title'],
      content: snap['content'],
      uId: snap['uId'],
      bookId: snap['bookId']
    );
    return note;
  }
}