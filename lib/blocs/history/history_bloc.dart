import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models.dart';
import '../../repository/repository.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;
  StreamSubscription<QuerySnapshot>? _historySubscription;

  HistoryBloc(this._historyRepository) : super(HistoryInitial()) {
    on<AddToHistoryEvent>(_onAddToHistory);
    on<LoadHistoryByBookId>(_onLoadHistoryByBookId);
    on<LoadedHistoryByUId>(_onLoadHistoryByUId);
    on<LoadedHistory>(_onLoadedHistory);
    on<UpdatedHistory>(_onUpdatedHistory);
    on<RemoveItemInHistory>(_onRemoveItemInHistory);
    on<LoadedHistoryStreamByUId>(_onLoadedHistoryStreamByUId);
    on<TopViewHistory>(_onTopViewHistory);
    on<UpdateTopViewHistory>(_onUpdateTopViewHistory);
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
      emit(HistoryAdded(histories: [history]));
    } catch (e) {
      emit(HistoryError('error in add'));
    }
  }

  void _onLoadHistoryByBookId(event, Emitter<HistoryState> emit) async {
    try {
      List<History> history =
          await _historyRepository.getHistories(event.bookId, event.uId);
      emit(HistoryLoadedById(histories: history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onLoadHistoryByUId(event, Emitter<HistoryState> emit) async {
    try {
      History history =
          await _historyRepository.getHistoryByUId(event.uId, event.bookId);
      emit(HistoryLoadedByUId(history: history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onLoadedHistory(LoadedHistory event, Emitter<HistoryState> emit) async {
    _historySubscription?.cancel();
    _historySubscription = _historyRepository.streamHistories(event.uId).listen(
      (snapshot) {
        List<History> histories =
            snapshot.docs.map((doc) => History.fromSnapshot(doc)).toList();
        add(UpdatedHistory(histories: histories));
      },
      onError: (error) {
        emit(HistoryError(error.toString()));
      },
    );
  }

  void _onLoadedHistoryStreamByUId(
      LoadedHistoryStreamByUId event, Emitter<HistoryState> emit) async {
    _historySubscription?.cancel();
    _historySubscription =
        _historyRepository.streamHistoriesByUId(event.uId, event.bookId).listen(
      (snapshot) {
        List<History> histories =
            snapshot.docs.map((doc) => History.fromSnapshot(doc)).toList();
        add(UpdatedHistory(histories: histories));
      },
      onError: (error) {
        emit(HistoryError(error.toString()));
      },
    );
  }

  void _onUpdatedHistory(UpdatedHistory event, Emitter<HistoryState> emit) {
    emit(HistoryLoaded(histories: event.histories));
  }

  void _onRemoveItemInHistory(event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      History history =
          await _historyRepository.removeItemInHistory(event.history);
      emit(HistoryLoaded(histories: [history]));
    } catch (e) {
      emit(HistoryError('error in add'));
    }
  }

  void _onTopViewHistory(event, Emitter<HistoryState> emit) async {
    _historySubscription?.cancel();
    _historySubscription = _historyRepository.streamAllHistories().listen(
          (snapshot) async {
        List<History> histories =
        snapshot.docs.map((doc) => History.fromSnapshot(doc)).toList();
        var groupedHistories = <String, int>{};

        for (var history in histories) {
          if (groupedHistories.containsKey(history.chapters)) {
            groupedHistories[history.chapters!] =
                (groupedHistories[history.chapters!] ?? 0) +
                    (history.times ?? 0);
          } else {
            groupedHistories[history.chapters!] = history.times ?? 0;
          }
        }

        if (groupedHistories.isNotEmpty) {
          final sortedHistories = groupedHistories.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final topThreeHistories = Map<String, int>.fromEntries(
            sortedHistories
          );

          BookRepository bookRepository = BookRepository();
          List<Book> books = [];

          await Future.wait(topThreeHistories.keys.map((key) async {
            final book = await bookRepository.getBookByBookId(key);
            books.add(book);
          }));

          add(UpdateTopViewHistory(book: books));
        }
      },
      onError: (error) {
        emit(HistoryError(error.toString()));
      },
    );
  }


  void _onUpdateTopViewHistory(event, Emitter<HistoryState> emit) {
    emit(HistoryTopView(book: event.book));
  }

  @override
  Future<void> close() {
    _historySubscription?.cancel();
    return super.close();
  }
}
