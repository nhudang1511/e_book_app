import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models.dart';
import '../../repository/repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  final BookRepository _bookRepository;
  SearchBloc(this._bookRepository) : super(SearchInitial()) {
    on<LoadSearchByTitle>(_onLoadSearchByTitle);
    on<LoadSearchByAuthor>(_onLoadSearchByAuthor);
  }
  void _onLoadSearchByTitle(event, Emitter<SearchState> emit) async {
    try {
      emit(SearchLoading());
      List<Book> searchedBook = [];
      final book = await _bookRepository.getAllBooks();
      for(var b in book){
        if(b.title!.toLowerCase().contains(event.words.toLowerCase())){
          searchedBook.add(b);
        }
      }
      emit(SearchLoaded(searchedBook: searchedBook));
    } catch (e) {
      emit(SearchFailure());
    }
  }
  void _onLoadSearchByAuthor(event, Emitter<SearchState> emit) async {
    try {
      emit(SearchLoading());
      List<Book> searchedBook = [];
      final book = await _bookRepository.getAllBooks();
      for(var b in book){
        if(b.authorName!.toLowerCase().contains(event.words.toLowerCase())){
          searchedBook.add(b);
        }
      }
      emit(SearchLoaded(searchedBook: searchedBook));
    } catch (e) {
      emit(SearchFailure());
    }
  }
}
