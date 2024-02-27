part of 'chapters_bloc.dart';
abstract class ChaptersEvent {
  const ChaptersEvent();
}

class LoadChapters extends ChaptersEvent {
  final String bookId;
  const LoadChapters(this.bookId);
}