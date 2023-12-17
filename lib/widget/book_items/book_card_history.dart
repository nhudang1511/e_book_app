import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';

class BookCardHistory extends StatelessWidget {
  final Book book;
  late bool inLibrary;
  final num percent;

  BookCardHistory({
    super.key,
    required this.book,
    required this.inLibrary, required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/book_detail',
          arguments: {'book': book, 'inLibrary': inLibrary},
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CategoryLoaded) {
              // Tạo danh sách tên danh mục từ categoryId trong book
              List<String> categoryNames = [];
              for (String categoryId in book.categoryId) {
                Category? category = state.categories.firstWhere(
                  (cat) => cat.id == categoryId,
                );
                if (category != null) {
                  categoryNames.add(category.name);
                }
              }
              return Row(
                children: [
                  Expanded(flex: 1, child: Image.network(book.imageUrl)),
                  const SizedBox(width: 5),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  BlocBuilder<AuthorBloc, AuthorState>(
                                    builder: (context, state) {
                                      if (state is AuthorLoading) {
                                        return const Expanded(
                                            child: CircularProgressIndicator());
                                      }
                                      if (state is AuthorLoaded) {
                                        Author? author =
                                            state.authors.firstWhere(
                                          (author) =>
                                              author.id == book.authodId,
                                        );
                                        return Text(
                                          author.fullName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  color:
                                                      const Color(0xFFC7C7C7),
                                                  fontWeight:
                                                      FontWeight.normal),
                                        );
                                      } else {
                                        return const Text(
                                            "Something went wrong");
                                      }
                                    },
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 3,
                            child: BlocBuilder<HistoryBloc, HistoryState>(
                              builder: (context, state) {
                                double percent = 0.0;
                                if (state is HistoryLoaded) {
                                  History? history = state.histories.firstWhere(
                                      (historyItem) =>
                                          historyItem.chapters == book.id);
                                  percent = double.parse((history.percent / 100)
                                      .toStringAsFixed(2));
                                }
                                return LinearPercentIndicator(
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2500,
                                  percent: percent,
                                  center: const Text(
                                    "",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  progressColor: const Color(0xFF8C2EEE),
                                );
                              },
                            ),
                          ),
                        ],
                      ))
                ],
              );
            } else {
              return const Text("Something went wrong");
            }
          },
        ),
      ),
    );
  }
}
