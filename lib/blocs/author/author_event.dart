part of 'author_bloc.dart';
abstract class AuthorEvent {
  const AuthorEvent();
}
class LoadedAuthor extends AuthorEvent{
}
class UpdateAuthor extends AuthorEvent{
  final List<Author> authors;
  const UpdateAuthor(this.authors);
}