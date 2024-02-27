import '../../model/models.dart';
abstract class BaseChaptersRepository{
  Future<Chapters> getChapters(String bookId);
}