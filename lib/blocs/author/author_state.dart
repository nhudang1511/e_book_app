part of 'author_bloc.dart';
abstract class AuthorState {
  const AuthorState();
}
class AuthorLoading extends AuthorState{
}
class AuthorAllLoaded extends AuthorState{
  final List<Author> authors;
  const AuthorAllLoaded({this.authors = const <Author>[]});
}
class AuthorFailure extends AuthorState{
}

class AuthorLoaded extends AuthorState{
  final Author author;
  const AuthorLoaded(this.author);
}