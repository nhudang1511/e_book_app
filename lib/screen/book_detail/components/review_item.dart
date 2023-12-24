import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                return Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
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
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/reviews',
                                  arguments: widget.book);
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
                              'ADD REVIEWS',
                              style: TextStyle(color: Colors.white),
                            )
                        )
                    )
                  ],
                );
              }
              else {
                return const Text('something went wrong');
              }
            },
          );
        }
        else {
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
