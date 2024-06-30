import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models.dart';
import '../../repository/repository.dart';

part 'audio_event.dart';

part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository _audioRepository;

  AudioBloc(this._audioRepository) : super(AudioLoading()) {
    on<LoadAudio>(_onLoadAudio);
  }

  void _onLoadAudio(event, emit) async {
    if (event.bookId.isEmpty) {
      // Throw an error if the audioId parameter is empty.
      throw Exception("The audioId parameter cannot be empty.");
    }
    try {
      Audio? audio = await _audioRepository.getChaptersAudio(event.bookId);
      if(audio != null){
        emit(AudioLoaded(audio: audio));
      }
      else{
        emit(AudioFailure());
      }
    } catch (e) {
      emit(AudioFailure());
    }
  }
}
