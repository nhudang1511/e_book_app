import 'package:e_book_app/model/models.dart';
abstract class BaseQuestionRepository{
  Future<List<Question>> getAllQuestion();
}