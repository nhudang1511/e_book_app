import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chapters extends Equatable{
  final String id;
  final String bookId;
  final Map<String,dynamic> chapterList;
  const Chapters({required this.id, required this.bookId, required this.chapterList});
  @override
  List<Object?> get props => [id, bookId, chapterList];

  static Chapters fromSnapshot(DocumentSnapshot snap) {
    Chapters chapters = Chapters(
        id: snap.id,
        bookId: snap['bookId'],
        chapterList: snap['chapterList']);
    return chapters;
  }
}