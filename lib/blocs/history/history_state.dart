part of 'history_bloc.dart';
abstract class HistoryState{
  const HistoryState();
}
class HistoryInitial extends HistoryState {
}

class HistoryLoading extends HistoryState {
}
class HistoryAdded extends HistoryState{
  final List<History> histories;
  HistoryAdded({this.histories =  const <History>[]});
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
class HistoryLoaded extends HistoryState {
  final List<History> histories;

  HistoryLoaded({required this.histories});
}