import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models.dart';
import '../../repository/repository.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryBloc(this._historyRepository)
      : super(HistoryInitial()) {
    on<AddToHistoryEvent>(_onAddToHistory);
    on<LoadHistory>(_onLoadHistory);
    on<LoadHistoryByBookId>(_onLoadHistoryByBookId);
    on<LoadedHistoryByUId>(_onLoadHistoryByUId);
  }

  void _onAddToHistory(event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final histories = History(
          uId: event.uId,
          chapters: event.chapters,
          percent: event.percent,
          times: event.times,
          chapterScrollPositions: event.chapterScrollPositions,
          chapterScrollPercentages: event.chapterScrollPercentages);
      // Thêm sách vào thư viện
      History history = await _historyRepository.addBookInHistory(histories);
      emit(HistoryLoaded(histories: [history]));
    } catch (e) {
      emit(HistoryError('error in add'));
    }
  }

  void _onLoadHistory(event, Emitter<HistoryState> emit) async {
    try {
      List<History> history = await _historyRepository.getAllHistories();
      emit(HistoryLoaded(histories: history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onLoadHistoryByBookId(event, Emitter<HistoryState> emit) async {
    try {
      List<History> history = await _historyRepository.getHistories(event.bookId, event.uId);
      emit(HistoryLoadedById(histories: history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onLoadHistoryByUId(event, Emitter<HistoryState> emit) async {
    try {
      History history = await _historyRepository.getHistoryByUId(event.uId, event.bookId);
      emit(HistoryLoadedByUId(history: history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
