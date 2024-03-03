import 'package:e_book_app/model/custom_model.dart';

class History extends CustomModel {
  final String? uId;
  final String? chapters;
  final num? percent;
  final int? times;
  final Map<String, dynamic>? chapterScrollPositions;
  final Map<String, dynamic>? chapterScrollPercentages;

  History(
      {this.uId,
      this.chapters,
      this.percent,
      this.times,
      this.chapterScrollPositions,
      this.chapterScrollPercentages});

  @override
  Map<String, Object> toJson() {
    return {
      'uId': uId!,
      'chapters': chapters!,
      'percent': percent!,
      'times': times!,
      'chapterScrollPositions': chapterScrollPositions!,
      'chapterScrollPercentages': chapterScrollPercentages!
    };
  }

  @override
  History fromJson(Map<String, dynamic> json) {
    History history = History(
        uId: json['uId'],
        chapters: json['chapters'],
        percent: json['percent'],
        times: json['times'],
        chapterScrollPositions: json['chapterScrollPositions'],
        chapterScrollPercentages: json['chapterScrollPercentages']);
    return history;
  }
}
