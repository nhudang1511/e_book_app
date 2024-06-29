part of 'audio_bloc.dart';
abstract class AudioEvent {
  const AudioEvent();
}

class LoadAudio extends AudioEvent {
  final String bookId;
  const LoadAudio(this.bookId);
}