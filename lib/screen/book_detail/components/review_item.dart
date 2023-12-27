import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:readmore/readmore.dart';
import '../../../blocs/blocs.dart';
import '../../../model/models.dart';

class ReviewItem extends StatefulWidget {
  final Book book;

  const ReviewItem({super.key, required this.book});

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthenticateState) {
          return StreamBuilder<QuerySnapshot>(
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
                    SizedBox(
                      height: 150,
                      child: reviews.isEmpty
                          ? const SizedBox()
                          : RatingSummary(
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
                        width: MediaQuery.of(context).size.width - 20,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/reviews',
                                  arguments: widget.book);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      100), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            child: const Text(
                              'ADD REVIEWS',
                              style: TextStyle(color: Colors.white),
                            )))
                  ],
                );
              } else {
                return const Text('something went wrong');
              }
            },
          );
        } else {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              100), // Adjust the radius as needed
                        ),
                      ),
                    ),
                    child: const Text(
                      'REVIEWS',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          );
        }
      },
    );
  }
}

class ReviewItemCard extends StatelessWidget {
  final String content;
  final String userId;
  final Timestamp time;
  final int rating;

  const ReviewItemCard(
      {super.key,
      required this.content,
      required this.userId,
      required this.time,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(
                0,
                5.0,
              ),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      child: BlocBuilder<ListUserBloc, ListUserState>(
        builder: (context, state) {
          if (state is ListUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ListUserLoaded) {
            User? user = state.users.firstWhere(
              (u) => u.id == userId,
            );
            //need fix
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(
                      rating.round(),
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ),
                  ),
                  ReadMoreText(
                    content,
                    trimLength: 50,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Map<int, int> countRatings(List<Review> reviews) {
  // Khởi tạo map để lưu trữ số lượng của từng rating
  Map<int, int> ratingCounts = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
  };

  // Đếm số lượng của từng rating trong danh sách đánh giá
  for (var review in reviews) {
    // Kiểm tra rating và tăng số lượng tương ứng
    ratingCounts[review.rating] = ratingCounts[review.rating]! + 1;
  }

  return ratingCounts;
}
