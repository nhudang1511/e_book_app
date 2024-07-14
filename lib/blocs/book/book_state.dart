part of 'book_bloc.dart';
abstract class BookState{
  const BookState();
}

class BookLoading extends BookState{
}
class BookLoaded extends BookState{
  final List<Book> books;
  DocumentSnapshot? lastDoc;
  BookLoaded({this.books = const <Book>[], this.lastDoc});
}
class BookPaginating extends BookState{
  final List<Book> books;
  DocumentSnapshot? lastDoc;
  BookPaginating({required this.books, this.lastDoc});
}
class BooksLoadAll extends BookState{
  final List<Book> books;
  BooksLoadAll({required this.books});
}
class BookFailure extends BookState{
  final String? error;
  BookFailure({this.error});
}
