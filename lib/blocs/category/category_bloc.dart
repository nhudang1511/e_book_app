import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  StreamSubscription? _streamSubscription;
  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository, super(CategoryLoading()){
        on<LoadCategory>(_onLoadCategory);
        on<UpdateCategory>(_onUpdateCategory);
  }
  void _onLoadCategory(event, Emitter emit) async{
    _streamSubscription?.cancel();
    _streamSubscription = _categoryRepository
        .getAllCategory()
        .listen((event) => add(UpdateCategory(event)));
  }
  void _onUpdateCategory(event, Emitter emit) async{
    emit(CategoryLoaded(categories: event.categories));
  }
}
