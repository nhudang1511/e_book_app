part of 'category_bloc.dart';
abstract class CategoryState{
  const CategoryState();
}
class CategoryLoading extends CategoryState{
}
class CategoryLoaded extends CategoryState{
  final List<Category> categories;
  const CategoryLoaded({this.categories = const <Category>[]});
}
class CategoryFailure extends CategoryState{

}