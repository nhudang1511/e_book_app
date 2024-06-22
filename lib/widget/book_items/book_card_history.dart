import 'package:e_book_app/screen/book_detail/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../model/models.dart';

class BookCardHistory extends StatefulWidget {
  final Book book;
  late bool inLibrary;
  final num percent;

  BookCardHistory({
    super.key,
    required this.book,
    required this.inLibrary,
    required this.percent,
  });

  @override
  State<BookCardHistory> createState() => _BookCardHistoryState();
}

class _BookCardHistoryState extends State<BookCardHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            BookDetailScreen.routeName,
            arguments: {'book': widget.book, 'inLibrary': widget.inLibrary},
          );
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 10) / 2,
          height: 150,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: [
              Expanded(
                  flex: 2, child: Image.network(widget.book.imageUrl ?? '')),
              const SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: (widget.percent.isNaN || widget.percent.isInfinite)
                    ? LinearPercentIndicator(
                        animation: true,
                        lineHeight: 4.0,
                        animationDuration: 2500,
                        percent: 0,
                        center: const Text(
                          "",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressColor: const Color(0xFF8C2EEE),
                      )
                    : LinearPercentIndicator(
                        animation: true,
                        lineHeight: 4.0,
                        animationDuration: 2500,
                        percent: widget.percent / 100,
                        center: const Text(
                          "",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressColor: const Color(0xFF8C2EEE),
                      ),
              )
            ],
          ),
        ));
  }
}
