import 'package:flutter/material.dart';

class TextNoteCard extends StatelessWidget {
  final String title;
  final String content;
  final String bookName;
  // final double height;

  const TextNoteCard(
      {super.key,
      required this.title,
      required this.content,
      required this.bookName,
      // required this.height
      });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 32, left: 32, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        width: currentWidth,
        // height: height,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      bookName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
