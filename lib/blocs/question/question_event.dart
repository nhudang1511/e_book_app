part of 'question_bloc.dart';

abstract class QuestionEvent{
  const QuestionEvent();
}

class LoadedQuestions extends QuestionEvent {
  LoadedQuestions();
}
class LoadedQuestionsByType extends QuestionEvent{
  final String type;
  LoadedQuestionsByType({required this.type});
}
class EditQuestions extends QuestionEvent {
  final Question question;

  const EditQuestions({
    required this.question
  });
}
class LoadedQuestionsByTypeExcludingId extends QuestionEvent{
  final String type;
  final String questionId;
  LoadedQuestionsByTypeExcludingId({required this.type, required this.questionId});
}
class LoadedQuestionsById extends QuestionEvent{
  final String questionId;
  LoadedQuestionsById({required this.questionId});
}
