part of 'history_bloc.dart';
abstract class HistoryState{
  const HistoryState();
}
class HistoryInitial extends HistoryState {
}

class HistoryLoading extends HistoryState {
}
class HistoryLoaded extends HistoryState{
  final List<Book> books;
  final List<History> histories;
  DocumentSnapshot? lastDoc;
  HistoryLoaded({this.books = const <Book>[], this.histories =  const <History>[], this.lastDoc});
}
class HistoryPaginating extends HistoryState{
  final List<Book> books;
  final List<History> histories;
  DocumentSnapshot? lastDoc;
  HistoryPaginating({required this.books, required this.histories, this.lastDoc});
}
class HistoryError extends HistoryState {
  final String error;
  HistoryError(this.error);
}

class HistoryLoadedById extends HistoryState {
  final List<History> histories;
  const HistoryLoadedById({required this.histories});
}

class HistoryLoadedByUId extends HistoryState {
  final History history;
  const HistoryLoadedByUId({required this.history});
}
