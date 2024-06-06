import '../../model/models.dart';
abstract class BaseBookRepository{
  Future<List<Book>> getAllBooks();
  Future<List<Book>> getBookByCategory(String cateId);
  Future<List<Book>> getBookByLibrary(List<Library> libraries);
  Future<Book> getBookById(String id);
}