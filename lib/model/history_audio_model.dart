import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/custom_model.dart';

class HistoryAudio extends CustomModel {
  final String? uId;
  final String? bookId;
  final num? percent;
  final int? times;
  final Map<String, dynamic>? chapterScrollPositions;
  final Map<String, dynamic>? chapterScrollPercentages;
  final String? id;

  HistoryAudio(
      {this.uId,
        this.bookId,
        this.percent,
        this.times,
        this.chapterScrollPositions,
        this.chapterScrollPercentages,
        this.id
      });

  @override
  Map<String, Object> toJson() {
    return {
      'uId': uId!,
      'bookId': bookId!,
      'percent': percent!,
      'times': times!,
      'chapterScrollPositions': chapterScrollPositions!,
      'chapterScrollPercentages': chapterScrollPercentages!
    };
  }

  @override
  HistoryAudio fromJson(Map<String, dynamic> json) {
    HistoryAudio history = HistoryAudio(
        uId: json['uId'],
        bookId: json['bookId'],
        percent: json['percent'],
        times: json['times'],
        chapterScrollPositions: json['chapterScrollPositions'],
        chapterScrollPercentages: json['chapterScrollPercentages'],
        id: json['id']
    );
    return history;
  }

  static HistoryAudio fromSnapshot(DocumentSnapshot snap) {
    HistoryAudio history = HistoryAudio(
        uId: snap['uId'],
        bookId: snap['bookId'],
        percent: snap['percent'],
        times: snap['times'],
        chapterScrollPositions: snap['chapterScrollPositions'],
        chapterScrollPercentages: snap['chapterScrollPercentages']);
    return history;
  }
}
