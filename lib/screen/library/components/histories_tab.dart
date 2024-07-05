import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blocs.dart';
import '../../../config/shared_preferences.dart';
import '../../../model/models.dart';
import '../../../repository/repository.dart';
import '../../../widget/book_items/list_book_history.dart';

class HistoriesTab extends StatelessWidget {
  const HistoriesTab({super.key, required this.uId, required this.book});

  final String uId;
  final List<Book> book;

  @override
  Widget build(BuildContext context) {
    return DisplayHistories(
      uId: uId,
      scrollDirection: Axis.vertical,
      height: MediaQuery
          .of(context)
          .size
          .height,
      inHistory: false,
      book: book,
    );
  }
}

class DisplayHistories extends StatefulWidget {
  const DisplayHistories({
    super.key,
    required this.uId,
    required this.scrollDirection,
    required this.height,
    required this.inHistory,
    required this.book,
  });

  final String? uId;
  final Axis scrollDirection;
  final double height;
  final bool inHistory;
  final List<Book> book;

  @override
  State<DisplayHistories> createState() => _DisplayHistoriesState();
}

class _DisplayHistoriesState extends State<DisplayHistories> {
  List<Book> matchingBooks = [];
  List<num> percent = [];
  late HistoryBloc historyBloc;

  @override
  void initState() {
    super.initState();
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
          return matchingBooks.isNotEmpty
              ? ListBookHistory(
            books: matchingBooks,
            scrollDirection: widget.scrollDirection,
            height: widget.height,
            inLibrary: false,
            percent: percent,
            inHistory: widget.inHistory,
          )
              : const SizedBox();
        },
      ),
    );
  }
}
