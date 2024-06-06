import 'package:e_book_app/repository/book/book_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/models.dart';
part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _bookRepository;

  BookBloc(this._bookRepository)
      :super(BookLoading()){
          on<LoadBooks>(_onLoadBook);
          on<LoadBooksByCateId>(_onLoadBookByCateId);
          on<LoadBooksByLibrary>(_onLoadBookByLibrary);
          // on<LoadBooksById>(_onLoadBookById);
  }
  void _onLoadBook(event, Emitter<BookState> emit) async{
    try {
      List<Book> books = await _bookRepository.getAllBooks();
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookFailure());
    }
  }
  void _onLoadBookByCateId(event, Emitter<BookState> emit) async{
    try {
      List<Book> books = await _bookRepository.getBookByCategory(event.cateId);
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookFailure());
    }
  }
  void _onLoadBookByLibrary(event, Emitter<BookState> emit) async{
    try {
      List<Book> books = await _bookRepository.getBookByLibrary(event.libraries);
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookFailure());
    }
  }
  // void _onLoadBookById(event, Emitter<BookState> emit) async{
  //   try {
  //     List<Book> books = await _bookRepository.getBookById(event.id);
  //     emit(BookLoaded(books: books));
  //   } catch (e) {
  //     emit(BookFailure());
  //   }
  // }
}
