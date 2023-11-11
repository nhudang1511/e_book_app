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
                  Text('100', style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary
                  )),
                  const Text('PAGES')
                ],
              ),
              Column(
                children: [
                  Text('12+', style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary)),
                  const Text('AGE')
                ],
              ),
              Column(
                children: [
                  Text('5.0', style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary)),
                  const Text('RATINGS')
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          ReadMoreText(
            book.description,
            trimLength: 300,
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                    onPressed: (){
                      if( state is AuthInitial || state is UnAuthenticateState){
                        Navigator.pushNamed(context, '/login');
                      }
                      else{
                        Navigator.pushNamed(context, '/book', arguments: book);
                      }
                },
                    child: const Text('READ', style: TextStyle(color: Colors.white),));
  },
),
          )
        ],
      ),
    );
  }

}