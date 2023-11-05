import 'package:flutter/material.dart';

import '../../model/models.dart';
import 'book_card_new.dart';

class ListBook extends StatelessWidget {
  final List<Book> books;
  final bool inLibrary;
  const ListBook({super.key, required this.books, required this.inLibrary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: books.length,
          itemBuilder: (context,index){
            return Padding(padding: EdgeInsets.all(8),
                child: BookCard(book: books[index], inLibrary: inLibrary,));
          }),
    );
  }
}
