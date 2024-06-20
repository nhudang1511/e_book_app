import 'package:e_book_app/repository/category/category_repository.dart';
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
  List<String> categoryNames = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          BookDetailScreen.routeName,
          arguments: {'book': widget.book, 'inLibrary': widget.inLibrary},
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF2A5B5),
        ),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Image.network(widget.book.imageUrl ?? '')),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(widget.book.title ?? '',
                          style:
                          Theme.of(context).textTheme.headlineSmall)),
                  Expanded(
                      flex: 1,
                      child: Text(widget.book.authorName ?? '')),
                  widget.book.price.toString() == '0'
                      ? const Icon(Icons.money_off)
                      : Text('Coins: ${widget.book.price.toString()}'),
                  Row(
                    children: [
                      const Icon(Icons.menu_book),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(widget.book.language ?? '')
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
