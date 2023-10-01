import 'package:e_book_app/widget/book_card_main.dart';
import 'package:flutter/material.dart';
import '../model/models.dart';


class ListBookMain extends StatelessWidget {
  final List<Book> books;
  const ListBookMain({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: books.length,
          itemBuilder: (context,index){
            return BookCardMain(book: books[index],);
          }),
    );
  }
}
