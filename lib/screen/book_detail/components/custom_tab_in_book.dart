import 'package:e_book_app/model/book_model.dart';
import 'package:e_book_app/screen/book_detail/components/review_item.dart';
import 'package:flutter/material.dart';

import 'detail_book_item.dart';
class CustomTabInBook extends StatelessWidget {
  final Book book;
  const CustomTabInBook({
    super.key,
    required this.book
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 ,
            child: TabBar(
              labelColor: Colors.black,
              indicator: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                color: Colors.white
              ),
              tabs: const [
                Tab(
                    text: 'Detail'
                ),
                Tab(
                  text: 'Reviews',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            height: MediaQuery.of(context).size.height/2, // Set an appropriate fixed height here
            child: TabBarView(children: [
              DetailBookItem(book: book,),
              ReviewItem(book: book),
            ]),
          )
        ],
      ),
    );
  }
}