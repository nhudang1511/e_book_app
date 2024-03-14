import 'package:e_book_app/widget/book_items/book_card_main.dart';
import 'package:flutter/material.dart';
import '../../model/models.dart';

class ListBookMain extends StatelessWidget {
  final List<Book> books;
  final Axis scrollDirection;
  final double height;
  final bool inLibrary;
  final String? uId;

  const ListBookMain(
      {super.key,
      required this.books,
      required this.scrollDirection,
      required this.height,
      required this.inLibrary, this.uId});

  @override
  Widget build(BuildContext context) {
    return inLibrary
        ? Expanded(
            child: ListView.builder(
                scrollDirection: scrollDirection,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCardMain(book: books[index], uId: uId, inLibrary: true,);
                }),
          )
        : SizedBox(
            height: height,
            child: ListView.builder(
                scrollDirection: scrollDirection,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCardMain(book: books[index], uId: uId, inLibrary: false,);
                }),
          );
  }
}
