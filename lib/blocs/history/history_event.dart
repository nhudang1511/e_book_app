part of 'history_bloc.dart';
abstract class HistoryEvent extends Equatable{
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}
class LoadHistory extends HistoryEvent{
  final String bookId;
  const LoadHistory(this.bookId);
  @override
  List<Object?> get props => [bookId];
}

class UpdateHistory extends HistoryEvent{
  final History histories;
  const UpdateHistory(this.histories);
  @override
  List<Object?> get props => [histories];
}
class AddToHistoryEvent extends HistoryEvent {
  final String uId;
  final String chapters;
  final double percent;
  final int times;
  final Map<String, dynamic> chapterScrollPositions;

  const AddToHistoryEvent({required this.uId, required this.chapters,
    required this.percent, required this.times, required this.chapterScrollPositions});

  @override
  List<Object?> get props => [uId,chapters,percent,times];
}