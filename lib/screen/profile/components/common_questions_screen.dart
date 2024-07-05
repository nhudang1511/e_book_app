import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book_app/blocs/blocs.dart';
import 'package:e_book_app/repository/question/question_repository.dart';
import 'package:e_book_app/widget/custom_dash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/models.dart';
import '../../../widget/widget.dart';

class CommonQuestionScreen extends StatefulWidget {
  const CommonQuestionScreen({super.key});

  static const String routeName = '/question';

  @override
  State<CommonQuestionScreen> createState() => _CommonQuestionScreenState();
}

class _CommonQuestionScreenState extends State<CommonQuestionScreen> {
  late QuestionBloc questionBloc;
  late List<Question> question = [];

  @override
  void initState() {
    super.initState();
    questionBloc = QuestionBloc(QuestionRepository())..add(LoadedQuestions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => questionBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          title: "Common Questions",
        ),
        body: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            if (state is QuestionLoaded) {
              question = state.questions;
              if (question.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: question.map((item) {
                      final Map<String, dynamic>? questions = item.questions;
                      return CustomQuestions(
                        title: item.title ?? '',
                        questions: questions ?? {},
                      );
                    }).toList(),
                  ),
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class CustomQuestions extends StatefulWidget {
  const CustomQuestions({
    super.key,
    required this.title,
    required this.questions,
  });

  final String title;
  final Map<String, dynamic> questions;

  @override
  State<CustomQuestions> createState() => _CustomQuestionsState();
}

class _CustomQuestionsState extends State<CustomQuestions> {
  bool showAnswer = false;
  late String? selectedQuestionKey;
  dynamic selectedQuestionValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomDash(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.questions.length,
          itemBuilder: (BuildContext context, int index) {
            final questionKey = widget.questions.keys.elementAt(index);
            final questionValue = widget.questions[questionKey];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      questionKey,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          if (showAnswer &&
                              selectedQuestionKey == questionKey) {
                            showAnswer = false;
                          } else {
                            showAnswer = true;
                            selectedQuestionKey = questionKey;
                            selectedQuestionValue = questionValue;
                          }
                        });
                      },
                      child: showAnswer
                          ? const Icon(Icons.expand_less_rounded)
                          : const Icon(Icons.expand_more_rounded))
                ],
              ),
            );
          },
        ),
        Visibility(
          visible: showAnswer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedQuestionValue.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        const CustomDash()
      ],
    );
  }
}
