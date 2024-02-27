part of 'author_bloc.dart';
abstract class AuthorState {
  const AuthorState();
}
class AuthorLoading extends AuthorState{
}
class AuthorLoaded extends AuthorState{
  final List<Author> authors;
  const AuthorLoaded({this.authors = const <Author>[]});
}
class AuthorFailure extends AuthorState{
}

