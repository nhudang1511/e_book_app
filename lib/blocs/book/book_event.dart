part of 'book_bloc.dart';
abstract class BookEvent{
  const BookEvent();
}

class LoadBooks extends BookEvent{
}
class LoadBooksByCateId extends BookEvent{
  final String cateId;
  LoadBooksByCateId(this.cateId);
}

class LoadBooksByLibrary extends BookEvent{
  final List<Library> libraries;
  LoadBooksByLibrary(this.libraries);
}
