import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';

class ReviewItem extends StatelessWidget {
  final Book book;

  const ReviewItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('review')
                .orderBy("time", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height/4,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final reviews = snapshot.data!.docs[index];
                        if (reviews['bookId'] == book.id) {
                          return ReviewItemCard(
                            content: reviews['content'],
                            userId: reviews['userId'],
                            time: reviews['time'],
                            rating: reviews['rating'],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                );
              } else {
                return Text('something went wrong');
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthenticateState) {
                  return ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reviews',
                            arguments: book);
                      },
                      child: const Text(
                        'ADD REVIEWS',
                        style: TextStyle(color: Colors.white),
                      ));
                } else {
                  return ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'ADD REVIEWS',
                        style: TextStyle(color: Colors.white),
                      ));
                }
              },
            ),
          )
        ],
      ),
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = TextSpan(text: content, style: const TextStyle(fontSize: 16));
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: 5, // Số dòng tối đa bạn muốn hiển thị
        );
        textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 50);
        return Container(
          height: textPainter.height + 150,
          width: MediaQuery.of(context).size.width - 50,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
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
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is ListUserLoaded) {
                User? user = state.users.firstWhere(
                      (u) => u.id == userId,
                );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipOval(
                        child: Image.network(user.imageUrl),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10,),
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
                          const SizedBox(height: 10,),
                          Expanded(
                              flex: 2,
                              child: SingleChildScrollView(
                                child: Text(
                                  content,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                              )
                          )

                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }

}
