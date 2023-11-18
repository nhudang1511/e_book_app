import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

import '../../../blocs/blocs.dart';
import '../../../model/book_model.dart';

class DetailBookItem extends StatelessWidget {
  final Book book;

  const DetailBookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(book.chapters.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                  const Text('CHAPTERS')
                ],
              ),
              Column(
                children: [
                  Text(book.country,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                  const Text('COUNTRY')
                ],
              ),
              Column(
                children: [
                  Text(book.price == 0 ? 'FREE' : book.price.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                  const Text('PRICE')
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ReadMoreText(
            book.description,
            trimLength: 300,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                    onPressed: () {
                      if (state is AuthInitial ||
                          state is UnAuthenticateState) {
                        Navigator.pushNamed(context, '/login');
                      } if(state is AuthenticateState) {
                        BlocProvider.of<ChaptersBloc>(context).add(LoadChapters(book.id));
                        Navigator.pushNamed(context, '/book', arguments: {'book': book, 'uId': state.authUser?.uid });
                      }
                    },
                    child: const Text(
                      'READ',
                      style: TextStyle(color: Colors.white),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
