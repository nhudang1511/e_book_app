import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/book_items/list_book_main.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({super.key});

  @override
  State<FavouritesTab> createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab> {
  List<Library> libraries = [];
  List<Book> matchingBooks = [];

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoaded) {
          libraries = state.libraries;
          return BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is BookLoaded) {
                matchingBooks = state.books
                    .where((book) => libraries
                    .any((library) => library.bookId == book.id))
                    .toList();
              }
              return matchingBooks.isNotEmpty ? Column(
                children: [
                  ListBookMain(
                      books: matchingBooks,
                      scrollDirection: Axis.vertical,
                      height: MediaQuery.of(context).size.height - 50,
                      inLibrary: true),
                ],
              ) : const SizedBox();
            },
          );
        }
        else {
          return const SizedBox();
        }
      },
    );
  }
}
