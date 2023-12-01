import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../widget/widget.dart';
import '../book_detail/components/review_item.dart';

class ReviewsScreen extends StatefulWidget {
  final Book book;

  const ReviewsScreen({super.key, required this.book});

  static const String routeName = '/reviews';

  static Route route({required Book book}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ReviewsScreen(book: book),
    );
  }

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final textEditingController = TextEditingController();
  final current = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Reviews'),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('review')
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final reviews = snapshot.data!.docs[index];
                          if (reviews['bookId'] == widget.book.id) {
                            return ReviewItemCard(
                              content: reviews['content'],
                              userId: reviews['userId'],
                              time: reviews['time'],
                            );
                          } else {
                            // Nếu không phù hợp, trả về một widget rỗng hoặc null
                            return SizedBox.shrink();
                          }
                        }),
                  );
                }
                else {
                  return Text('something went wrong');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: textEditingController,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Please',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                )),
                IconButton(
                    onPressed: () {
                      if (textEditingController.text.isNotEmpty) {
                        BlocProvider.of<ReviewBloc>(context).add(
                            AddNewReviewEvent(
                                bookId: widget.book.id,
                                content: textEditingController.text,
                                status: true,
                                userId: current!.uid,
                                time: Timestamp.now()));
                        setState(() {
                          textEditingController.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_circle_up)),
                //Text(current!.uid)
              ],
            ),
          )
        ],
      ),
    );
  }
}
