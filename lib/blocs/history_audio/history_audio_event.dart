part of 'history_audio_bloc.dart';

abstract class HistoryAudioEvent{
  const HistoryAudioEvent();
}
class AddToHistoryAudioEvent extends HistoryAudioEvent {
  final String uId;
  final String bookId;
  final num percent;
  final int times;
  final Map<String, dynamic> chapterScrollPositions;
  final Map<String, dynamic> chapterScrollPercentages;

  const AddToHistoryAudioEvent(
      {required this.uId,
        required this.bookId,
        required this.percent,
        required this.times,
        required this.chapterScrollPositions,
        required this.chapterScrollPercentages});
}
class LoadHistoryAudioByBookId extends HistoryAudioEvent {
  final String bookId;
  final String uId;
  LoadHistoryAudioByBookId(this.bookId, this.uId);
}