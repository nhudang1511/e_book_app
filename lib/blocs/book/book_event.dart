part of 'book_bloc.dart';
abstract class BookEvent{
  const BookEvent();
}

class LoadBooks extends BookEvent{
}
class LoadBooksPaginating extends BookEvent{
  LoadBooksPaginating();
}