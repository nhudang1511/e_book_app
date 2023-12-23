import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/book_items/list_book_main.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({super.key, required this.uId});

  final String uId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            SingleChildScrollView(child: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibraryLoaded) {
              List<Library> libraries = state.libraries
                  .where((element) => element.userId == uId)
                  .toList();
              return BlocBuilder<BookBloc, BookState>(
                builder: (context, state) {
                  if (state is BookLoaded) {
                    List<Book> matchingBooks = state.books
                        .where((book) => libraries
                            .any((library) => library.bookId == book.id))
                        .toList();
                    if (matchingBooks.isNotEmpty) {
                      return ListBookMain(
                          books: matchingBooks,
                          scrollDirection: Axis.vertical,
                          height: MediaQuery.of(context).size.height - 50,
                          inLibrary: true);
                    } else {
                      return const Text('No matching books found');
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
        )),
      ),
    );
  }
}
