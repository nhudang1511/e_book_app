import '../../model/models.dart';
abstract class BaseAuthorRepository{
  Future<List<Author>> getAllAuthors();
  Future<Author> getAuthorById(String authorId);

}