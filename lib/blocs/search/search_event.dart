part of 'search_bloc.dart';
abstract class SearchEvent{
  const SearchEvent();
}

class LoadSearchByTitle extends SearchEvent{
  final String words;
  LoadSearchByTitle({required this.words});
}
class LoadSearchByAuthor extends SearchEvent{
  final String words;
  LoadSearchByAuthor({required this.words});
}