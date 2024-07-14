import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/repository/book/book_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/models.dart';

part 'book_event.dart';

part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _bookRepository;

  BookBloc(this._bookRepository) : super(BookLoading()) {
    on<LoadBooks>(_onLoadBook);
    on<LoadBooksPaginating>(_onLoadBooksPaginating);
  }

  void _onLoadBook(event, Emitter<BookState> emit) async {
    try {
      // Not paginating.
      emit(BookLoading());
      final book = await _bookRepository.readBooks();
      emit(BookLoaded(books: book.$1, lastDoc: book.$2));
    } catch (e) {
      emit(BookFailure(error: e.toString()));
    }
  }


  void _onLoadBooksPaginating(event, Emitter<BookState> emit) async {
    try {
      if (state is! BookPaginating) {
        final currentState = state as BookLoaded;
        if (currentState.lastDoc != null) {
          emit(BookPaginating(
              books: currentState.books, lastDoc: currentState.lastDoc));
          final books = await _bookRepository.readBooks(
              startAfterDoc: currentState.lastDoc);
          emit(BookLoaded(
              books: currentState.books + books.$1, lastDoc: books.$2));
        }
      }
    } catch (e) {
      emit(BookFailure(error: e.toString()));
    }
  }
}
