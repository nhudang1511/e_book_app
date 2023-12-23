import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/book_items/list_book_history.dart';
import '../../../widget/widget.dart';

class HistoriesTab extends StatelessWidget {
  const HistoriesTab({super.key, required this.uId});

  final String uId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              child: DisplayHistories(
        uId: uId,
        scrollDirection: Axis.vertical,
        height: MediaQuery.of(context).size.height,
        scroll: false,inHistory: false,
      ))),
    );
  }
}

class DisplayHistories extends StatelessWidget {
  const DisplayHistories({
    super.key,
    required this.uId,
    required this.scrollDirection,
    required this.height,
    required this.scroll, required this.inHistory,
  });

  final String? uId;
  final Axis scrollDirection;
  final double height;
  final bool scroll;
  final bool inHistory;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('histories')
          .where('uId', isEqualTo: uId)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<History> histories = snapshot.data!.docs.map((doc) {
            return History.fromSnapshot(doc);
          }).toList();
          return BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is BookLoaded) {
                List<Book> matchingBooks = state.books
                    .where((book) =>
                        histories.any((item) => item.chapters == book.id))
                    .toList();
                if (matchingBooks.isNotEmpty) {
                  List<num> percent = [];
                  for (var book in matchingBooks) {
                    List<History> matchedHistories = histories
                        .where((item) => item.chapters == book.id)
                        .toList();
                    for (var history in matchedHistories) {
                      //print('Book ID: ${book.id}, Percent: ${history.percent}');
                      // Do something with history.percent here
                      percent.add(history.percent);
                    }
                  }
                  return Column(
                    children: [
                      inHistory ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SectionTitle(title: 'Continue Reading'),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/library',
                                );
                              },
                              icon: const Icon(Icons.more_horiz_outlined))
                        ],
                      ) : const SizedBox(),
                      ListBookHistory(
                        books: matchingBooks,
                        scrollDirection: scrollDirection,
                        height: height,
                        scroll: scroll,
                        inLibrary: true,
                        percent: percent,
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
