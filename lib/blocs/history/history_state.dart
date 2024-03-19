part of 'history_bloc.dart';
abstract class HistoryState{
  const HistoryState();
}
class HistoryInitial extends HistoryState {
}

class HistoryLoading extends HistoryState {
}

class HistoryLoaded extends HistoryState {
  final List<History> histories;
  const HistoryLoaded({required this.histories});
}

class HistoryError extends HistoryState {
  final String error;
  HistoryError(this.error);
}

class HistoryLoadedById extends HistoryState {
  final History history;
  const HistoryLoadedById({required this.history});
}
