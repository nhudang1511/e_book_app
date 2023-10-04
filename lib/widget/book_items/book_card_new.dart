import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({
    super.key, required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 132,
      width: (MediaQuery.of(context).size.width)/2.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF2A5B5),),
      child: Row(
        children: [
          Expanded(flex:2, child: Text(book.title, style: Theme.of(context).textTheme.headlineSmall )),
          Expanded(
              flex:1, 
              child: BlocBuilder<AuthorBloc, AuthorState>(
                builder: (context, state) {
                  if(state is AuthorLoading){
                    return CircularProgressIndicator();
                  }
                  if(state is AuthorLoaded){
                    Author? author = state.authors.firstWhere(
                          (author) => author.id == book.authodId,
                    );
                    return Text(author.fullName);
                  }
                  else{
                    return Text('Somthing went wrong');
                  }
                  },
              )
          ),
          Expanded(flex:3,child: Image.network(book.imageUrl))
        ],
      ),
    );
  }
}
