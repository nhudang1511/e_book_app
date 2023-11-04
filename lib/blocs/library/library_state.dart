part of 'library_bloc.dart';
abstract class LibraryState extends Equatable {
  const LibraryState();
  @override
  List<Object?> get props => [];
}
class LibraryInitial extends LibraryState {
  @override
  List<Object?> get props => [];
}

class LibraryLoading extends LibraryState {
  @override
  List<Object?> get props => [];
}

class LibraryLoaded extends LibraryState {
  final List<Library> libraries;
  const LibraryLoaded({this.libraries = const <Library>[]});
  @override
  List<Object?> get props => [libraries];
}

class LibraryError extends LibraryState {
  final String error;

  LibraryError(this.error);

  @override
  List<Object?> get props => [error];
}
