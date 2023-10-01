import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_book_app/repository/book/book_repository.dart';
import 'package:equatable/equatable.dart';
import '../../model/models.dart';
part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _bookRepository;
  StreamSubscription? _bookSubscription;

  BookBloc({required BookRepository bookRepository})
      : _bookRepository = bookRepository,
        super(BookLoading()){
          on<LoadBooks>(_onLoadBook);
          on<UpdateBook>(_onUpdateBook);
  }
  void _onLoadBook(event, Emitter<BookState> emit) async{
    _bookSubscription?.cancel();
    _bookSubscription =
        _bookRepository
            .getAllBooks()
            .listen((event) => add(UpdateBook(event)));
  }
  void _onUpdateBook(event, Emitter<BookState> emit) async{
    emit(BookLoaded(books: event.books));
  }
}
