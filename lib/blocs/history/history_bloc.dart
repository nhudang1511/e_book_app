import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/models.dart';
import '../../repository/repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;
  StreamSubscription? _historySubscription;
  HistoryBloc({required HistoryRepository historyRepository})
      : _historyRepository = historyRepository,
        super(HistoryInitial()){
    on<AddToHistoryEvent>(_onAddToHistory);
    on<LoadHistory>(_onLoadHistory);
    on<UpdateHistory>(_onUpdateHistory);
  }
  void _onAddToHistory(event, Emitter<HistoryState> emit) async{
    final histories = History(uId: event.uId, chapters: event.chapters, percent: event.percent);
    _historySubscription?.cancel();
    emit(HistoryLoading());
    try {
      // Thêm sách vào thư viện
      await _historyRepository.addBookInHistory(histories);
      emit(HistoryLoaded(histories: event.histories));
    } catch (e) {
      emit(HistoryError('error in add'));
    }
  }
  void _onLoadHistory(event, Emitter<HistoryState> emit) async{
    emit(HistoryLoading());
    _historySubscription?.cancel();
    _historySubscription =
        _historyRepository
            .getAllHistories()
            .listen((event) => add(UpdateHistory(event)));
  }
  void _onUpdateHistory(event, Emitter<HistoryState> emit) async{
    emit(HistoryLoaded(histories: event.histories));
  }
}
