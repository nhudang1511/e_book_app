import '../../model/models.dart';
abstract class BaseAuthorRepository{
  Stream<List<Author>> getAllAuthors();
}