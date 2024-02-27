part of 'library_bloc.dart';
abstract class LibraryState {
  const LibraryState();
}
class LibraryInitial extends LibraryState {
}

class LibraryLoading extends LibraryState {
}

class LibraryLoaded extends LibraryState {
  final List<Library> libraries;
  const LibraryLoaded({this.libraries = const <Library>[]});
}

class LibraryError extends LibraryState {
  final String error;

  LibraryError(this.error);
}
