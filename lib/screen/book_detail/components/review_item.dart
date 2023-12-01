import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  height: 100,
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

  const ReviewItemCard(
      {super.key,
      required this.content,
      required this.userId,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width - 50,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Theme.of(context).colorScheme.primary)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: ClipOval(
              child: Image.asset('assets/image/quote_image_1.png'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if(state is UserLoaded && state.user.id == userId){
                      return Text(
                        state.user.fullName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    }
                    else{
                      return Text(
                        userId,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),
                Expanded(
                    flex: 2,
                    child: Text(content,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
