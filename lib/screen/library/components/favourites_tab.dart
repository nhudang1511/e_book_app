import 'package:e_book_app/repository/library/library_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/book_items/list_book_main.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({super.key, required this.uId});

  final String uId;

  @override
  State<FavouritesTab> createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab> {
  LibraryBloc libraryBloc = LibraryBloc(LibraryRepository());

  @override
  void initState() {
    super.initState();
    libraryBloc.add(LoadLibrary(widget.uId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => libraryBloc,
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoaded) {
            List<Library> libraries = state.libraries;
            return BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoaded) {
                  List<Book> matchingBooks = state.books
                      .where((book) =>
                      libraries
                          .any((library) => library.bookId == book.id))
                      .toList();
                  if (matchingBooks.isNotEmpty) {
                    return Column(
                      children: [
                        ListBookMain(
                          books: matchingBooks,
                          scrollDirection: Axis.vertical,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height - 50,
                          inLibrary: true,
                          uId: widget.uId,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
                }
              },
            );
          }
          else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
