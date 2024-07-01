part of 'question_bloc.dart';
abstract class QuestionState {
  const QuestionState();
}
class QuestionInitial extends QuestionState {
}
class QuestionLoading extends QuestionState{
}
class QuestionLoaded extends QuestionState{
  final List<Question> questions;
  const QuestionLoaded({this.questions = const <Question>[]});
}
class QuestionError extends QuestionState {
  final String error;

  const QuestionError(this.error);
}