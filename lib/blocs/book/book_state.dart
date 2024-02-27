part of 'book_bloc.dart';
abstract class BookState{
  const BookState();
}

class BookLoading extends BookState{
}
class BookLoaded extends BookState{
  final List<Book> books;
  const BookLoaded({this.books = const <Book>[]});
}
class BookFailure extends BookState{
}
