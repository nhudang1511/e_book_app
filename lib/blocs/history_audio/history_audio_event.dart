part of 'history_audio_bloc.dart';

abstract class HistoryAudioEvent {
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

class LoadHistoryAudio extends HistoryAudioEvent {
  final String uId;

  LoadHistoryAudio({required this.uId});
}

class UpdatedHistoryAudio extends HistoryAudioEvent {
  final List<HistoryAudio> historiesAudio;

  UpdatedHistoryAudio({required this.historiesAudio});
}

class RemoveItemInHistoryAudio extends HistoryAudioEvent{
  final HistoryAudio historyAudio;

  RemoveItemInHistoryAudio({required this.historyAudio});

}
class LoadedHistoryAudioByUId extends HistoryAudioEvent {
  final String uId;
  final String bookId;

  LoadedHistoryAudioByUId({required this.uId, required this.bookId});
}
