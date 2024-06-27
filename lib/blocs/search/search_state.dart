part of 'search_bloc.dart';
abstract class SearchState{
  const SearchState();
}
class SearchInitial extends SearchState{}
class SearchLoading extends SearchState{
}
class SearchLoaded extends SearchState{
  final List<Book> searchedBook;
  SearchLoaded({required this.searchedBook});
}
class SearchFailure extends SearchState{
}
