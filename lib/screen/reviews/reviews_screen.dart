import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rating_summary/rating_summary.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
import '../../widget/widget.dart';
import '../book_detail/components/review_item.dart';

class ReviewsScreen extends StatefulWidget {
  final Book book;

  const ReviewsScreen({super.key, required this.book});

  static const String routeName = '/reviews';

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final textEditingController = TextEditingController();
  final current = FirebaseAuth.instance.currentUser;
  bool isReviewed = false;
  late Timer _timer;
  ReviewBloc reviewBloc = ReviewBloc( reviewRepository: ReviewRepository());
  HistoryBloc historyBloc = HistoryBloc(HistoryRepository());
  @override
  void initState() {
    super.initState();
    historyBloc.add(LoadHistory());
    reviewBloc.add(LoadedReview());
  }

  @override
  void dispose() {
    super.dispose();
    reviewBloc.close();
    historyBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => reviewBloc),
        BlocProvider(create: (_) => historyBloc)
      ],
      child: Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        appBar: const CustomAppBar(title: 'Reviews'),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('review')
                .orderBy("time", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Review> reviews = snapshot.data!.docs.map((doc) {
                  return Review(
                    bookId: doc['bookId'],
                    content: doc['content'],
                    status: doc['status'],
                    userId: doc['userId'],
                    time: doc['time'],
                    rating: doc['rating'],
                  );
                }).toList();
                reviews = reviews
                    .where((element) => element.bookId == widget.book.id)
                    .toList();
                if(current?.uid != null){
                  isReviewed = reviews.any((review) => review.userId == current?.uid);
                }
                // Đếm số lượng của từng rating
                int ratingOneCount = 0;
                int ratingTwoCount = 0;
                int ratingThreeCount = 0;
                int ratingFourCount = 0;
                int ratingFiveCount = 0;
                double average = 0;
                if (reviews.isNotEmpty) {
                  Map<int, int> ratingCounts = countRatings(reviews);
                  ratingOneCount = ratingCounts[1] ?? 0;
                  ratingTwoCount = ratingCounts[2] ?? 0;
                  ratingThreeCount = ratingCounts[3] ?? 0;
                  ratingFourCount = ratingCounts[4] ?? 0;
                  ratingFiveCount = ratingCounts[5] ?? 0;

                  average = (ratingOneCount +
                      ratingTwoCount*2 +
                      ratingThreeCount*3 +
                      ratingFourCount*4 +
                      ratingFiveCount*5) /
                      reviews.length;
                }
                return Column(
                  children: [
                    reviews.isEmpty
                        ? const SizedBox()
                        : Container(
                      margin: const EdgeInsets.only(bottom: 10),
                          child: RatingSummary(
                      counter: reviews.length,
                      average: average,
                      showAverage: true,
                      counterFiveStars: ratingFiveCount,
                      counterFourStars: ratingFourCount,
                      counterThreeStars: ratingThreeCount,
                      counterTwoStars: ratingTwoCount,
                      counterOneStars: ratingOneCount,
                    ),
                        ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            if (reviews[index].bookId == widget.book.id) {
                              return ReviewItemCard(
                                content: reviews[index].content ?? '',
                                userId: reviews[index].userId ?? '',
                                time: reviews[index].time!,
                                rating: reviews[index].rating ?? 0,
                              );
                            } else {
                              // Nếu không phù hợp, trả về một widget rỗng hoặc null
                              return const SizedBox.shrink();
                            }
                          }),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('something went wrong'));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           if(!isReviewed){
             if(current?.uid != null){
               showDialog(
                   context: context,
                   barrierDismissible: true,
                   // set to false if you want to force a rating
                   builder: (context) {
                     return BlocBuilder<HistoryBloc, HistoryState>(
                       builder: (context, state) {
                         if (state is HistoryLoaded) {
                           final historyFull = state.histories.where((element) =>
                           element.percent == 10000 &&
                               element.uId == current!.uid &&
                               element.chapters == widget.book.id);
                           if (historyFull.isNotEmpty) {
                             return RatingDialog(
                               starSize: 30,
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
                               image: Image.asset(
                                 'assets/logo/logo.png',
                               ),
                               submitButtonText: 'Submit',
                               commentHint: 'Add your reviews',
                               onCancelled: () => print('cancelled'),
                               onSubmitted: (response) {
                                reviewBloc.add(
                                     AddNewReviewEvent(
                                         bookId: widget.book.id ?? '',
                                         content: response.comment,
                                         status: true,
                                         userId: current!.uid,
                                         rating: response.rating.round(),
                                         time: Timestamp.now()));
                               },
                             );
                           }
                           else {
                             _timer = Timer(
                                 const Duration(seconds: 1), () {
                               Navigator.of(context).pop();
                             });
                             return const CustomDialogNotice(
                               title: Icons.warning,
                               content:
                               'Please read full books to add review',
                             );
                           }
                         } else {
                           return const Center(
                             child: CircularProgressIndicator(),
                           );
                         }
                       },
                     );
                   });
             }
             else{
               _timer = Timer(
                   const Duration(seconds: 1), () {
                 Navigator.of(context).pop();
               });
               showDialog(
                   context: context,
                   builder: (BuildContext context) {
                 return const CustomDialogNotice(
                   title: Icons.warning,
                   content: 'Please log in to review',
                 );
               },);
             }
           }
           else{
             _timer = Timer(
                 const Duration(seconds: 1), () {
               Navigator.of(context).pop();
             });
             showDialog(
                 context: context,
                 builder: (BuildContext context) {
               return const CustomDialogNotice(
                 title: Icons.warning,
                 content: 'Each account can only rate a book once',
               );
             },);
           }
          },
          backgroundColor: const Color(0xFF8C2EEE),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
