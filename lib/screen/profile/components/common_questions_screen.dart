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

class CustomQuestions extends StatelessWidget {
  const CustomQuestions({
    super.key,
    required this.title,
    required this.questions,
  });

  final String title;
  final Map<String, dynamic> questions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomDash(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: questions.length,
          itemBuilder: (BuildContext context, int index) {
            final questionKey = questions.keys.elementAt(index);
            final questionValue = questions[questionKey];
            return InkWell(
              onTap: () {
                print(questionValue);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  questionKey,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 16),
                ),
              ),
            );
          },
        ),
        const CustomDash()
      ],
    );
  }
}
