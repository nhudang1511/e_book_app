import '../../model/models.dart';
abstract class BaseBookRepository{
  Stream<List<Book>> getAllBooks();
}