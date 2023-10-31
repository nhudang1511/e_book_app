part of 'author_bloc.dart';
abstract class AuthorState {
  const AuthorState();

  @override
  List<Object?> get props => [];
}
class AuthorLoading extends AuthorState{
  @override
  List<Object?> get props => [];

}
class AuthorLoaded extends AuthorState{
  final List<Author> authors;
  const AuthorLoaded({this.authors = const <Author>[]});
  @override
  List<Object?> get props => [authors];
}

