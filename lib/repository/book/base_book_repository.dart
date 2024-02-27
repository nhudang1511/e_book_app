import '../../model/models.dart';
abstract class BaseBookRepository{
  Future<List<Book>> getAllBooks();
}