part of 'author_bloc.dart';
abstract class AuthorEvent {
  const AuthorEvent();
}
class LoadedAllAuthor extends AuthorEvent{
}
class LoadedAuthor extends AuthorEvent{
  final String authorId;
  LoadedAuthor(this.authorId);
}