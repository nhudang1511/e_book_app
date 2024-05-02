import 'package:e_book_app/config/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/book_items/list_book_main.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({super.key, required this.book});

  @override
  State<FavouritesTab> createState() => _FavouritesTabState();

  final List<Book> book;
}

class _FavouritesTabState extends State<FavouritesTab> {
  List<Library> libraries = [];
  List<Book> matchingBooks = [];

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
              ? Column(
                  children: [
                    ListBookMain(
                        books: matchingBooks,
                        scrollDirection: Axis.vertical,
                        height: MediaQuery.of(context).size.height - 50,
                        inLibrary: true),
                  ],
                )
              : const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
