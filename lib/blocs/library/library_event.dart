part of 'library_bloc.dart';
abstract class LibraryEvent{
  const LibraryEvent();
}
class LoadLibrary extends LibraryEvent{
}
class AddToLibraryEvent extends LibraryEvent {
  final String userId;
  final String bookId;

  const AddToLibraryEvent({required this.userId, required this.bookId});
}
class RemoveFromLibraryEvent extends LibraryEvent {
  final String userId;
  final String bookId;

  const RemoveFromLibraryEvent({required this.userId, required this.bookId});
}

class LoadLibraryByUid extends LibraryEvent{
  final String userId;
  LoadLibraryByUid(this.userId);
}

