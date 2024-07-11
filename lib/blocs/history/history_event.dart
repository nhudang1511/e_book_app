part of 'history_bloc.dart';

abstract class HistoryEvent{
  const HistoryEvent();
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
class LoadedHistoryByUId extends HistoryEvent {
  final String uId;
  final String bookId;
  LoadedHistoryByUId({required this.uId, required this.bookId});
}
class LoadedHistory extends HistoryEvent {
  final String uId;

  LoadedHistory({required this.uId});
}
class LoadedHistoryStreamByUId extends HistoryEvent {
  final String uId;
  final String bookId;

  LoadedHistoryStreamByUId({required this.uId, required this.bookId});
}
class UpdatedHistory extends HistoryEvent {
  final List<History> histories;

  UpdatedHistory({required this.histories});
}
class RemoveItemInHistory extends HistoryEvent{
  final History history;

  RemoveItemInHistory({required this.history});
}
