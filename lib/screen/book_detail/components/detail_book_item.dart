import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

import '../../../blocs/blocs.dart';
import '../../../model/book_model.dart';

class DetailBookItem extends StatefulWidget {
  final Book book;

  const DetailBookItem({super.key, required this.book});

  @override
  State<DetailBookItem> createState() => _DetailBookItemState();
}

class _DetailBookItemState extends State<DetailBookItem> {
  String uId = '';
  @override
  void initState() {
    super.initState();
    uId = SharedService.getUserId() ?? '';
  }

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
                  Text(widget.book.chapters.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                  const Text('CHAPTERS')
                ],
              ),
              Column(
                children: [
                  Text(widget.book.country ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                  const Text('COUNTRY')
                ],
              ),
              Column(
                children: [
                  Text(
                      widget.book.price == 0
                          ? 'FREE'
                          : widget.book.price.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                  const Text('PRICE')
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ReadMoreText(
            widget.book.description ?? '',
            trimLength: 300,
          ),
          const SizedBox(
            height: 10,
          ),
          if (uId != '')
            SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: ElevatedButton(
                  onPressed: () {
                    final Map<String, dynamic> tempPosition = {};
                    final Map<String, dynamic> tempPercent = {};
                    BlocProvider.of<ChaptersBloc>(context)
                        .add(LoadChapters(widget.book.id ?? ''));
                    BlocProvider.of<HistoryBloc>(context)
                        .add(LoadHistory());
                    Navigator.pushNamed(context, '/book', arguments: {
                      'book': widget.book,
                      'uId': uId,
                      'chapterScrollPositions': tempPosition,
                      'chapterScrollPercentages': tempPercent,
                    });
                  },
                  style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            100), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: const Text('READ',
                      style: TextStyle(color: Colors.white)),
                ))
          else
            SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            100), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: const Text('READ',
                      style: TextStyle(color: Colors.white)),
                ))
        ],
      ),
    );
  }
}
