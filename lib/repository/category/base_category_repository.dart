import 'package:e_book_app/model/category_model.dart';
abstract class BaseCategoryRepository{
  Future<List<Category>> getAllCategory();
}