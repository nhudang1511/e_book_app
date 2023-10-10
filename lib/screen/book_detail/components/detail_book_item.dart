import 'package:flutter/material.dart';

import '../../../model/book_model.dart';

class DetailBookItem extends StatelessWidget {
  final Book book;
  const DetailBookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('100', style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary
                  )),
                  const Text('PAGES')
                ],
              ),
              Column(
                children: [
                  Text('12+', style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary)),
                  const Text('AGE')
                ],
              ),
              Column(
                children: [
                  Text('5.0', style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary)),
                  const Text('RATINGS')
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Text(book.description),
          const SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: ElevatedButton(
                onPressed: (){},
                child: const Text('READ', style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
}