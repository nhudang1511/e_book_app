import 'package:e_book_app/config/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/book_items/book_card_main.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({super.key, required this.book});

  @override
  State<FavouritesTab> createState() => _FavouritesTabState();

  final List<Book> book;
}

class _FavouritesTabState extends State<FavouritesTab> {
  List<Library> libraries = [];
  List<Book> matchingBooks = [];
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
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoaded) {
          libraries = state.libraries;
          matchingBooks = widget.book
              .where((book) => libraries.any((library) =>
                  library.bookId == book.id &&
                  library.userId == SharedService.getUserId()))
              .toList();
          return matchingBooks.isNotEmpty
              ? BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    if (state is BookLoaded) {
                      isPaginating = false;
                      if(state.lastDoc != null && matchingBooks.length <= 4){
                        isPaginating = true;
                        context.read<BookBloc>().add(LoadBooksPaginating());
                      }
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              controller: controller,
                              scrollDirection: Axis.vertical,
                              itemCount: matchingBooks.length,
                              itemBuilder: (context, index) {
                                return BookCardMain(
                                  book: matchingBooks[index],
                                  inLibrary: true,
                                );
                              }),
                        ),
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
                )
              : const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
