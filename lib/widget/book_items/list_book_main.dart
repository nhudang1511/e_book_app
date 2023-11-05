import 'package:e_book_app/widget/book_items/book_card_main.dart';
import 'package:flutter/material.dart';
import '../../model/models.dart';


class ListBookMain extends StatelessWidget {
  final List<Book> books;
  final Axis scrollDirection;
  final double height;
  final bool inLibrary;
  const ListBookMain({super.key, required this.books, required this.scrollDirection, required this.height, required this.inLibrary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
          scrollDirection: scrollDirection,
          itemCount: books.length,
          itemBuilder: (context,index){
            return BookCardMain(book: books[index], inLibrary: inLibrary);
          }),
    );
  }
}
