part of 'audio_bloc.dart';
abstract class AudioState{
  const AudioState();
}
class AudioLoading extends AudioState{
}
class AudioLoaded extends AudioState{
  final Audio audio;
  const AudioLoaded({required this.audio});
}
class AudioFailure extends AudioState{

}