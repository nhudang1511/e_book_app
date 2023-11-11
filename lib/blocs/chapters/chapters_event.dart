part of 'chapters_bloc.dart';
abstract class ChaptersEvent {
  const ChaptersEvent();
  @override
  List<Object?> get props => [];
}

class LoadChapters extends ChaptersEvent {
  final String bookId;
  const LoadChapters(this.bookId);
  @override
  List<Object?> get props => [bookId];
}
class UpdateChapters extends ChaptersEvent{
  final Chapters chapters;
  const UpdateChapters({required this.chapters});
  @override
  List<Object?> get props => [chapters];
}