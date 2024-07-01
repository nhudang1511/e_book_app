import 'package:e_book_app/model/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/question/question_repository.dart';

part 'question_event.dart';

part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionRepository _questionRepository;

  QuestionBloc(this._questionRepository) : super(QuestionInitial()) {
    on<LoadedQuestions>(_onLoadQuestions);
  }

  void _onLoadQuestions(event, Emitter<QuestionState> emit) async {
    try {
      List<Question> question = await _questionRepository.getAllQuestion();
      emit(QuestionLoaded(questions: question));
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }

}
