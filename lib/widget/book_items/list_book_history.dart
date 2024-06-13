import 'package:flutter/material.dart';
import '../../model/models.dart';
import 'book_card_history.dart';

class ListBookHistory extends StatelessWidget {
  final List<Book> books;
  final Axis scrollDirection;
  final double height;
  final bool inLibrary;
  final bool inHistory;
  final List<num> percent;

  const ListBookHistory(
      {super.key,
      required this.books,
      required this.scrollDirection,
      required this.height,
      required this.inLibrary,
      required this.percent,
      required this.inHistory});

  @override
  Widget build(BuildContext context) {
    return inHistory
        ? SizedBox(
            height: height,
            child: ListView.builder(
                scrollDirection: scrollDirection,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCardHistory(
                      book: books[index],
                      inLibrary: inLibrary,
                      percent: percent[index]);
                }),
          )
        : Expanded(
            child: GridView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: books.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) => BookCardHistory(
                book: books[index],
                inLibrary: inLibrary,
                percent: percent[index]),
          ));
  }
}
