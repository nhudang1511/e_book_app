import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_dialog/rating_dialog.dart';

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
                              rating: reviews['rating'],
                            );
                          } else {
                            // Nếu không phù hợp, trả về một widget rỗng hoặc null
                            return const SizedBox.shrink();
                          }
                        }),
                  );
                }
                else {
                  return const Text('something went wrong');
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            barrierDismissible: true, // set to false if you want to force a rating
            builder: (context) {
              return RatingDialog(
                initialRating: 1.0,
                // your app's name?
                title: const Text(
                  'Rating Dialog',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // encourage your user to leave a high rating?
                message: const Text(
                  'Tap to rate the book',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                // your app's logo?
                image: Image.asset('assets/logo/logo.png', height: 100),
                submitButtonText: 'Submit',
                commentHint: 'Add your reviews',
                onCancelled: () => print('cancelled'),
                onSubmitted: (response) {
                  //print('rating: ${response.rating}, comment: ${response.comment}');
                  BlocProvider.of<ReviewBloc>(context).add(
                      AddNewReviewEvent(
                          bookId: widget.book.id,
                          content: response.comment,
                          status: true,
                          userId: current!.uid,
                          rating: response.rating.round(),
                          time: Timestamp.now()));
                },
              );
            }
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

