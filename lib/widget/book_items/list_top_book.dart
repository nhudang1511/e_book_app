import 'package:flutter/material.dart';

import '../../model/models.dart';
import '../../screen/screen.dart';

class ListTopBook extends StatelessWidget {
  final List<Book> books;

  const ListTopBook({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.pushNamed(
                context,
                BookDetailScreen.routeName,
                arguments: {'book': books[index], 'inLibrary': false},
              );
            },
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: [
                      Image.network(
                        books[index].imageUrl ?? '',
                        height: 140,
                      ),
                      Text(
                        books[index].title ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
