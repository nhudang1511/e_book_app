part of 'history_audio_bloc.dart';
abstract class HistoryAudioState{
  const HistoryAudioState();
}
class HistoryAudioInitial extends HistoryAudioState {
}

class HistoryAudioLoading extends HistoryAudioState {
}
class HistoryAudioLoaded extends HistoryAudioState{
  final List<HistoryAudio> historyAudio;
  HistoryAudioLoaded({this.historyAudio =  const <HistoryAudio>[]});
}
class HistoryAudioError extends HistoryAudioState {
  final String error;
  HistoryAudioError(this.error);
}

class HistoryAudioLoadedById extends HistoryAudioState {
  final List<HistoryAudio> historyAudio;
  const HistoryAudioLoadedById({required this.historyAudio});
}

class HistoryAudioLoadedByUId extends HistoryAudioState {
  final HistoryAudio history;
  const HistoryAudioLoadedByUId({required this.history});
}
