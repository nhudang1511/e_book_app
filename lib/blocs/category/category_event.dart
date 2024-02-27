part of 'category_bloc.dart';
abstract class CategoryEvent {
  const CategoryEvent();
}

class LoadCategory extends CategoryEvent{
}
class UpdateCategory extends CategoryEvent{
  final List<Category> categories;
  const UpdateCategory(this.categories);
}