import 'package:flutter/material.dart';
import '../../model/models.dart';
import 'book_card_history.dart';


class ListBookHistory extends StatelessWidget {
  final List<Book> books;
  final Axis scrollDirection;
  final double height;
  final bool inLibrary;
  final List<num> percent;
  const ListBookHistory({super.key, required this.books, required this.scrollDirection, required this.height, required this.inLibrary, required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
          scrollDirection: scrollDirection,
          itemCount: books.length,
          itemBuilder: (context,index){
            return BookCardHistory(book: books[index], inLibrary: inLibrary, percent: percent[index]);
          }),
    );
  }
}
