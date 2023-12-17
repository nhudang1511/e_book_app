import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class History extends Equatable {
  final String uId;
  final String chapters;
  final num percent;
  final int times;
  final Map<String,dynamic> chapterScrollPositions;

  const History(
      {required this.uId,
      required this.chapters,
      required this.percent,
      required this.times,
      required this.chapterScrollPositions});

  @override
  List<Object?> get props =>
      [uId, chapters, percent, times, chapterScrollPositions];

  Map<String, Object> toDocument() {
    return {
      'uId': uId,
      'chapters': chapters,
      'percent': percent,
      'times': times,
      'chapterScrollPositions': chapterScrollPositions
    };
  }

  static History fromSnapshot(DocumentSnapshot snap) {
    History history = History(
        uId: snap['uId'],
        chapters: snap['chapters'],
        percent: snap['percent'],
        times: snap['times'],
        chapterScrollPositions: snap['chapterScrollPositions']);
    return history;
  }
}
