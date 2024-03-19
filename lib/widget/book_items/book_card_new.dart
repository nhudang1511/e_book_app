import 'package:e_book_app/screen/book_detail/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../repository/author/author_repository.dart';

class BookCard extends StatefulWidget {
  final Book book;
  late bool inLibrary;

  BookCard({super.key, required this.book, required this.inLibrary});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  AuthorBloc authorBloc = AuthorBloc(AuthorRepository());

  @override
  void initState() {
    super.initState();
    authorBloc.add(LoadedAuthor(widget.book.authodId ?? ''));
  }


  @override
  void dispose() {
    super.dispose();
    authorBloc.close();

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authorBloc,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            BookDetailScreen.routeName,
            arguments: {'book': widget.book, 'inLibrary': widget.inLibrary},
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 132,
          width: (MediaQuery.of(context).size.width) / 2.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF2A5B5),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(widget.book.title ?? '',
                      style: Theme.of(context).textTheme.headlineSmall)),
              Expanded(
                  flex: 1,
                  child: BlocBuilder<AuthorBloc, AuthorState>(
                    builder: (context, state) {
                      if (state is AuthorLoading) {
                        return const CircularProgressIndicator();
                      }
                      if (state is AuthorLoaded) {
                        Author? author = state.author;
                        return Text(author.fullName ?? '');
                      } else {
                        return const Text('Somthing went wrong');
                      }
                    },
                  )),
              Expanded(
                  flex: 3, child: Image.network(widget.book.imageUrl ?? ''))
            ],
          ),
        ),
      ),
    );
  }
}
