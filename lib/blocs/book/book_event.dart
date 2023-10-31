part of 'book_bloc.dart';
abstract class BookEvent extends Equatable{
  const BookEvent();
  @override
  List<Object?> get props => [];
}

class LoadBooks extends BookEvent{
  @override
  List<Object?> get props => [];
}

class UpdateBook extends BookEvent{
  final List<Book> books;
  const UpdateBook(this.books);
  @override
  List<Object?> get props => [books];
}