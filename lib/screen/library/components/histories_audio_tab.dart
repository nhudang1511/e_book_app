import 'package:e_book_app/config/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../repository/repository.dart';
import '../../../widget/widget.dart';

class HistoriesAudioTab extends StatefulWidget {
  const HistoriesAudioTab({super.key, required this.uId, required this.book});

  final String uId;
  final List<Book> book;

  @override
  State<HistoriesAudioTab> createState() => _HistoriesAudioTabState();
}

class _HistoriesAudioTabState extends State<HistoriesAudioTab> {
  ScrollController controller = ScrollController();
  bool isPaginating = false;
  List<Book> matchingBooks = [];
  List<num> percent = [];
  late HistoryAudioBloc historyAudioBloc;

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
    historyAudioBloc = HistoryAudioBloc(HistoryAudioRepository())
      ..add(LoadHistoryAudio(uId: SharedService.getUserId() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => historyAudioBloc,
      child: BlocBuilder<HistoryAudioBloc, HistoryAudioState>(
        builder: (context, state) {
          if (state is HistoryAudioLoaded) {
            List<HistoryAudio> histories = state.historyAudio;
            matchingBooks = widget.book
                .where(
                    (book) => histories.any((item) => item.bookId == book.id))
                .toList();
            if (matchingBooks.isNotEmpty) {
              percent = [];
              for (var book in matchingBooks) {
                List<HistoryAudio> matchedHistories =
                    histories.where((item) => item.bookId == book.id).toList();
                for (var history in matchedHistories) {
                  percent.add(history.percent!);
                }
              }
            }
          }
          return matchingBooks.isNotEmpty
              ? Column(
                  children: [
                    BlocBuilder<BookBloc, BookState>(
                      builder: (context, state) {
                        if (state is BookLoaded) {
                          isPaginating = false;
                          if (state.lastDoc != null &&
                              widget.book.length <= 8) {
                            isPaginating = true;
                            context.read<BookBloc>().add(LoadBooksPaginating());
                          }
                        }
                        return Expanded(
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
                        ));
                      },
                    ),
                    isPaginating
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ))
                        : const SizedBox()
                  ],
                )
              : const SizedBox();
        },
      ),
    );
  }
}
