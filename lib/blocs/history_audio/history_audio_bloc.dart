import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models.dart';
import '../../repository/repository.dart';

part 'history_audio_event.dart';

part 'history_audio_state.dart';

class HistoryAudioBloc extends Bloc<HistoryAudioEvent, HistoryAudioState> {
  final HistoryAudioRepository _historyAudioRepository;
  StreamSubscription<QuerySnapshot>? _historyAudioSubscription;

  HistoryAudioBloc(this._historyAudioRepository)
      : super(HistoryAudioInitial()) {
    on<AddToHistoryAudioEvent>(_onAddToHistoryAudio);
    on<LoadHistoryAudioByBookId>(_onLoadHistoryAudioByBookId);
    on<LoadHistoryAudio>(_onLoadHistoryAudio);
    on<UpdatedHistoryAudio>(_onUpdatedHistoryAudio);
    on<RemoveItemInHistoryAudio>(_onRemoveItemInHistoryAudio);
    on<LoadedHistoryAudioByUId>(_onLoadHistoryAudioByUId);
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
      HistoryAudio historyAudio =
          await _historyAudioRepository.addBookInHistoryAudio(historiesAudio);
      emit(HistoryAudioLoaded(historyAudio: [historyAudio]));
    } catch (e) {
      print(e.toString());
      emit(HistoryAudioError('error in add'));
    }
  }

  void _onLoadHistoryAudioByBookId(
      event, Emitter<HistoryAudioState> emit) async {
    try {
      List<HistoryAudio> historyAudio = await _historyAudioRepository
          .getHistoryAudio(event.bookId, event.uId);
      emit(HistoryAudioLoadedById(historyAudio: historyAudio));
    } catch (e) {
      emit(HistoryAudioError(e.toString()));
    }
  }

  void _onLoadHistoryAudio(
      LoadHistoryAudio event, Emitter<HistoryAudioState> emit) async {
    _historyAudioSubscription?.cancel();
    _historyAudioSubscription =
        _historyAudioRepository.streamHistoriesAudio(event.uId).listen(
      (snapshot) {
        List<HistoryAudio> histories =
            snapshot.docs.map((doc) => HistoryAudio.fromSnapshot(doc)).toList();
        add(UpdatedHistoryAudio(historiesAudio: histories));
      },
      onError: (error) {
        emit(HistoryAudioError(error.toString()));
      },
    );
  }

  void _onUpdatedHistoryAudio(
      UpdatedHistoryAudio event, Emitter<HistoryAudioState> emit) {
    emit(HistoryAudioLoaded(historyAudio: event.historiesAudio));
  }

  void _onLoadHistoryAudioByUId(
      LoadedHistoryAudioByUId event, Emitter<HistoryAudioState> emit) async {
    _historyAudioSubscription?.cancel();
    _historyAudioSubscription =
        _historyAudioRepository.streamHistoriesAudioByUId(event.uId, event.bookId).listen(
              (snapshot) {
            List<HistoryAudio> histories =
            snapshot.docs.map((doc) => HistoryAudio.fromSnapshot(doc)).toList();
            add(UpdatedHistoryAudio(historiesAudio: histories));
          },
          onError: (error) {
            emit(HistoryAudioError(error.toString()));
          },
        );
  }

  void _onRemoveItemInHistoryAudio(
      event, Emitter<HistoryAudioState> emit) async {
    emit(HistoryAudioLoading());
    try {
      HistoryAudio historyAudio = await _historyAudioRepository
          .removeItemInHistoryAudio(event.historyAudio);
      emit(HistoryAudioLoaded(historyAudio: [historyAudio]));
    } catch (e) {
      //print(e.toString());
      emit(HistoryAudioError('error in add'));
    }
  }

  @override
  Future<void> close() {
    _historyAudioSubscription?.cancel();
    return super.close();
  }
}
