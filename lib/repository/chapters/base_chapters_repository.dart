import '../../model/models.dart';
abstract class BaseChaptersRepository{
  Stream<Chapters> getChapter(String bookId);
}