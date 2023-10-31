part of 'category_bloc.dart';
abstract class CategoryEvent {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategory extends CategoryEvent{
  @override
  List<Object?> get props => [];
}
class UpdateCategory extends CategoryEvent{
  final List<Category> categories;
  const UpdateCategory(this.categories);
  @override
  List<Object?> get props => [];
}