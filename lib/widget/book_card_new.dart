import 'package:flutter/material.dart';

import '../model/models.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({
    super.key, required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 132,
      width: (MediaQuery.of(context).size.width)/2.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF2A5B5),),
      child: Row(
        children: [
          Expanded(flex:2, child: Text(book.title, style: Theme.of(context).textTheme.headlineMedium )),
          Expanded(flex:2, child: Text(book.authodId)),
          Expanded(flex:3,child: Image.network(book.imageUrl))
        ],
      ),
    );
  }
}
