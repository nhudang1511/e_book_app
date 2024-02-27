import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  CategoryBloc(this._categoryRepository)
      : super(CategoryLoading()){
        on<LoadCategory>(_onLoadCategory);
  }
  void _onLoadCategory(event, Emitter emit) async{
    try {
      List<Category> category = await _categoryRepository.getAllCategory();
      emit(CategoryLoaded(categories: category));
    } catch (e) {
      emit(CategoryFailure());
    }
  }
}
