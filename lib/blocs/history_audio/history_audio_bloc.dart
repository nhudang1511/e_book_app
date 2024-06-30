import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models.dart';
import '../../repository/repository.dart';

part 'history_audio_event.dart';

part 'history_audio_state.dart';

class HistoryAudioBloc extends Bloc<HistoryAudioEvent, HistoryAudioState> {
  final HistoryAudioRepository _historyAudioRepository;

  HistoryAudioBloc(this._historyAudioRepository) : super(HistoryAudioInitial()) {
    on<AddToHistoryAudioEvent>(_onAddToHistoryAudio);
    on<LoadHistoryAudioByBookId>(_onLoadHistoryAudioByBookId);
  }

  void _onAddToHistoryAudio(event, Emitter<HistoryAudioState> emit) async {
    emit(HistoryAudioLoading());
    try {
      final historiesAudio = HistoryAudio(
          uId: event.uId,
          bookId: event.bookId,
          percent: event.percent,
          times: event.times,
          chapterScrollPositions: event.chapterScrollPositions,
          chapterScrollPercentages: event.chapterScrollPercentages);
      // Thêm sách vào thư viện
      HistoryAudio historyAudio = await _historyAudioRepository.addBookInHistoryAudio(historiesAudio);
      emit(HistoryAudioLoaded(historyAudio: [historyAudio]));
    } catch (e) {
      print(e.toString());
      emit(HistoryAudioError('error in add'));
    }
  }

  void _onLoadHistoryAudioByBookId(event, Emitter<HistoryAudioState> emit) async {
    try {
      List<HistoryAudio> historyAudio =
      await _historyAudioRepository.getHistoryAudio(event.bookId, event.uId);
      emit(HistoryAudioLoadedById(historyAudio: historyAudio));
    } catch (e) {
      emit(HistoryAudioError(e.toString()));
    }
  }
}
