part of 'author_bloc.dart';
abstract class AuthorEvent {
  const AuthorEvent();
  @override
  List<Object?> get props => [];
}
class LoadedAuthor extends AuthorEvent{
  @override
  List<Object?> get props => [];
}
class UpdateAuthor extends AuthorEvent{
  final List<Author> authors;
  const UpdateAuthor(this.authors);
  @override
  List<Object?> get props => [authors];
}