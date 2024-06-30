import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../../widget/widget.dart';

class ListBookHistory extends StatefulWidget {
  final List<Book> books;
  final Axis scrollDirection;
  final double height;
  final bool inLibrary;
  final bool inHistory;
  final List<num> percent;
  final bool isPaginating;

  const ListBookHistory(
      {super.key,
      required this.books,
      required this.scrollDirection,
      required this.height,
      required this.inLibrary,
      required this.percent,
      required this.inHistory,
      this.isPaginating = false});

  @override
  State<ListBookHistory> createState() => _ListBookHistoryState();
}

class _ListBookHistoryState extends State<ListBookHistory> {
  ScrollController controller = ScrollController();
  bool isPaginating = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return widget.inHistory
        ? Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SectionTitle(title: 'Continue Reading'),
                ],
              ),
              SizedBox(
                height: widget.height,
                child: ListView.builder(
                    scrollDirection: widget.scrollDirection,
                    itemCount:
                        widget.books.length > 4 ? 4 : widget.books.length,
                    itemBuilder: (context, index) {
                      return BookCardHistory(
                          book: widget.books[index],
                          inLibrary: widget.inLibrary,
                          percent: widget.percent[index]);
                    }),
              ),
            ],
          )
        : BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is BookLoaded) {
                isPaginating = false;
                if (state.lastDoc != null && widget.books.length <= 8) {
                  isPaginating = true;
                  context.read<BookBloc>().add(LoadBooksPaginating());
                }
              }
              return Column(
                children: [
                  Expanded(
                      child: GridView.builder(
                    controller: controller,
                    padding: const EdgeInsets.all(5),
                    itemCount: widget.books.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) => BookCardHistory(
                        book: widget.books[index],
                        inLibrary: widget.inLibrary,
                        percent: widget.percent[index]),
                  )),
                  isPaginating
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ))
                      : const SizedBox()
                ],
              );
            },
          );
  }
}
