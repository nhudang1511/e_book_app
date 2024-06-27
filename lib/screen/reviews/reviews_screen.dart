import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/repository/mission/mission_repository.dart';
import 'package:e_book_app/repository/mission_user/mission_user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rating_summary/rating_summary.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
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
  bool isReviewed = false;
  late Timer _timer;
  late MissionBloc missionBloc;
  late MissionUserBloc missionUserBloc;
  List<Mission> mission = [];
  MissionUser missionUser = MissionUser();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    missionBloc = MissionBloc(MissionRepository())
      ..add(LoadedMissionsByType(type: 'comment'));
    missionUserBloc = MissionUserBloc(MissionUserRepository());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => missionBloc,
        ),
        BlocProvider(create: (context) => missionUserBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<MissionBloc, MissionState>(
            listener: (context, state) {
              //print('m: $state');
              if (state is MissionLoadedByType) {
                mission = state.mission;
                mission.sort((a, b) => Comparable.compare(b.times as Comparable, a.times as Comparable),);
                for(var m in mission){
                  print(m.id);
                  missionUserBloc.add(LoadedMissionsUserById(
                      missionId: m.id ?? '',
                      uId: SharedService.getUserId() ?? ''));
                }
              }
            },
          ),
          BlocListener<MissionUserBloc, MissionUserState>(
              listener: (context, state) {
            //print(state);
            if (state is MissionUserLoaded) {
              missionUser = MissionUser(
                uId: state.mission.uId,
                times: state.mission.times! + 1,
                missionId: state.mission.missionId,
                status: true,
                id: state.mission.id
              );
            } else if (state is MissionUserError) {
            }
          })
        ],
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const CustomAppBar(title: 'Reviews'),
          body: SingleChildScrollView(
            child: BlocBuilder<ReviewBloc, ReviewState>(
              builder: (context, state) {
                if (state is ReviewLoaded) {
                  List<Review> reviews = state.reviews;
                  reviews = reviews
                      .where((element) => element.bookId == widget.book.id)
                      .toList();
                  if (SharedService.getUserId() != null) {
                    isReviewed = reviews.any(
                        (review) => review.userId == SharedService.getUserId());
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
                            ratingTwoCount * 2 +
                            ratingThreeCount * 3 +
                            ratingFourCount * 4 +
                            ratingFiveCount * 5) /
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
                                  rating: reviews[index].rating!,
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
              if (!isReviewed) {
                if (SharedService.getUserId() != null) {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      // set to false if you want to force a rating
                      builder: (context) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('histories')
                                .where('uId',
                                    isEqualTo: SharedService.getUserId())
                                .where("chapters", isEqualTo: widget.book.id)
                                .where("percent", isEqualTo: 100)
                                .snapshots(),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData) {
                                List<History> historyFull =
                                    snapshot.data!.docs.map((doc) {
                                  return History.fromSnapshot(doc);
                                }).toList();
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
                                      BlocProvider.of<ReviewBloc>(context).add(
                                          AddNewReviewEvent(
                                              bookId: widget.book.id ?? '',
                                              content: response.comment,
                                              status: true,
                                              userId:
                                                  SharedService.getUserId() ??
                                                      '',
                                              rating: response.rating.round(),
                                              time: Timestamp.now()));
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          _timer = Timer(
                                              const Duration(seconds: 1), () {
                                              missionUserBloc.add(
                                                  EditMissionUsers(
                                                      mission: missionUser));
                                            BlocProvider.of<ReviewBloc>(context)
                                                .add(LoadedReview());
                                            Navigator.of(context).pop();
                                          });
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ).then((value) {
                                        if (_timer.isActive) {
                                          _timer.cancel();
                                        }
                                      });
                                    },
                                  );
                                } else {
                                  _timer =
                                      Timer(const Duration(seconds: 1), () {
                                    Navigator.of(context).pop();
                                  });
                                  return const CustomDialogNotice(
                                    title: Icons.warning,
                                    content:
                                        'Please read full books to add review',
                                  );
                                }
                              } else {
                                return const CircularProgressIndicator();
                              }
                            });
                      });
                } else {
                  _timer = Timer(const Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CustomDialogNotice(
                        title: Icons.warning,
                        content: 'Please log in to review',
                      );
                    },
                  );
                }
              } else {
                _timer = Timer(const Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialogNotice(
                      title: Icons.warning,
                      content: 'Each account can only rate a book once',
                    );
                  },
                );
              }
            },
            backgroundColor: const Color(0xFF8C2EEE),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
