part of 'history_bloc.dart';

abstract class HistoryEvent{
  const HistoryEvent();
}

class LoadHistory extends HistoryEvent {
}
class AddToHistoryEvent extends HistoryEvent {
  final String uId;
  final String chapters;
  final num percent;
  final int times;
  final Map<String, dynamic> chapterScrollPositions;
  final Map<String, dynamic> chapterScrollPercentages;

  const AddToHistoryEvent(
      {required this.uId,
      required this.chapters,
      required this.percent,
      required this.times,
      required this.chapterScrollPositions,
      required this.chapterScrollPercentages});
}

class LoadHistoryByBookId extends HistoryEvent {
  final String bookId;
  final String uId;
  LoadHistoryByBookId(this.bookId, this.uId);
}

