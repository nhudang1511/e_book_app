import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../config/shared_preferences.dart';
import '../../../model/models.dart';
import '../../../repository/repository.dart';
import '../../../widget/widget.dart';

class HistoriesTab extends StatefulWidget {
  const HistoriesTab({super.key, required this.uId, required this.book});

  final String uId;
  final List<Book> book;

  @override
  State<HistoriesTab> createState() => _HistoriesTabState();
}

class _HistoriesTabState extends State<HistoriesTab> {
  ScrollController controller = ScrollController();
  bool isPaginating = false;
  List<Book> matchingBooks = [];
  List<num> percent = [];
  late HistoryBloc historyBloc;

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      isPaginating = true;
      context.read<BookBloc>().add(LoadBooksPaginating());
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
    historyBloc = HistoryBloc(HistoryRepository())
      ..add(LoadedHistory(uId: SharedService.getUserId() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => historyBloc,
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded) {
            List<History> histories = state.histories;
            matchingBooks = widget.book
                .where(
                    (book) => histories.any((item) => item.chapters == book.id))
                .toList();
            if (matchingBooks.isNotEmpty) {
              percent = [];
              for (var book in matchingBooks) {
                List<History> matchedHistories = histories
                    .where((item) => item.chapters == book.id)
                    .toList();
                for (var history in matchedHistories) {
                  percent.add(history.percent!);
                }
              }
            }
          }
          return BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is BookLoaded) {
                isPaginating = false;
                if (state.lastDoc != null && matchingBooks.length <= 8) {
                  isPaginating = true;
                  context.read<BookBloc>().add(LoadBooksPaginating());
                }
              }
              return matchingBooks.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                            child: GridView.builder(
                          controller: controller,
                          padding: const EdgeInsets.all(5),
                          itemCount: matchingBooks.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) => BookCardHistory(
                              book: matchingBooks[index],
                              inLibrary: true,
                              percent: percent[index]),
                        )),
                        isPaginating
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ))
                            : const SizedBox()
                      ],
                    )
                  : matchingBooks.isEmpty && isPaginating
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox();
            },
          );
        },
      ),
    );
  }
}
