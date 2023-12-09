part of 'history_bloc.dart';
abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}
class HistoryInitial extends HistoryState {
  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {
  @override
  List<Object?> get props => [];
}

class HistoryLoaded extends HistoryState {
  final List<History> histories;
  const HistoryLoaded({required this.histories});
  @override
  List<Object?> get props => [histories];
}

class HistoryError extends HistoryState {
  final String error;

  HistoryError(this.error);

  @override
  List<Object?> get props => [error];
}
