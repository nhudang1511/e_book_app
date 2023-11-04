part of 'library_bloc.dart';
abstract class LibraryEvent extends Equatable{
  const LibraryEvent();
  @override
  List<Object?> get props => [];
}
class LoadLibrary extends LibraryEvent{
  @override
  List<Object?> get props => [];
}

class UpdateLibrary extends LibraryEvent{
  final List<Library> libraries;
  const UpdateLibrary(this.libraries);
  @override
  List<Object?> get props => [libraries];
}
class AddToLibraryEvent extends LibraryEvent {
  final String userId;
  final String bookId;

  const AddToLibraryEvent({required this.userId, required this.bookId});

  @override
  List<Object?> get props => [userId, bookId];
}
class RemoveFromLibraryEvent extends LibraryEvent {
  final String userId;
  final String bookId;

  const RemoveFromLibraryEvent({required this.userId, required this.bookId});

  @override
  List<Object?> get props => [userId, bookId];
}