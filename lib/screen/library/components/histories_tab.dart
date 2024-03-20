import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/book_items/list_book_history.dart';
import '../../../widget/widget.dart';

class HistoriesTab extends StatelessWidget {
  const HistoriesTab({super.key, required this.uId, required this.book});

  final String uId;
  final List<Book> book;

  @override
  Widget build(BuildContext context) {
    return DisplayHistories(
      uId: uId,
      scrollDirection: Axis.vertical,
      height: MediaQuery.of(context).size.height,
      inHistory: false, book: book,
    );
  }
}

class DisplayHistories extends StatefulWidget {
  const DisplayHistories({
    super.key,
    required this.uId,
    required this.scrollDirection,
    required this.height,
    required this.inHistory, required this.book,
  });

  final String? uId;
  final Axis scrollDirection;
  final double height;
  final bool inHistory;
  final List<Book> book;

  @override
  State<DisplayHistories> createState() => _DisplayHistoriesState();
}

class _DisplayHistoriesState extends State<DisplayHistories> {
  List<Book> matchingBooks = [];
  List<num> percent = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('histories')
          .where('uId', isEqualTo: widget.uId)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<History> histories = snapshot.data!.docs.map((doc) {
            return History.fromSnapshot(doc);
          }).toList();
          matchingBooks = widget.book
              .where((book) =>
              histories.any((item) => item.chapters == book.id))
              .toList();
          if (matchingBooks.isNotEmpty) {
            percent = [];
            for (var book in matchingBooks) {
              List<History> matchedHistories = histories
                  .where((item) => item.chapters == book.id)
                  .toList();
              for (var history in matchedHistories) {
                //print('Book ID: ${book.id}, Percent: ${history.percent}');
                // Do something with history.percent here
                percent.add(history.percent!);
              }
            }
          }
          return matchingBooks.isNotEmpty ? Column(
            children: [
              widget.inHistory ? const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SectionTitle(title: 'Continue Reading'),
                ],
              ) : const SizedBox(),
              ListBookHistory(
                books: matchingBooks,
                scrollDirection: widget.scrollDirection,
                height: widget.height,
                inLibrary: false,
                percent: percent, inHistory: widget.inHistory,
              ),
            ],
          ) : const SizedBox();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
