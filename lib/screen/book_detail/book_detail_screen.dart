import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
import 'components/custom_tab_in_book.dart';

class BookDetailScreen extends StatelessWidget {
  static const String routeName = '/book_detail';

  static Route route({required Book book}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => BookDetailScreen(book: book));
  }
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_outlined, color: Color(0xFFDFE2E0),)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.share, color: Color(0xFFDFE2E0),)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.download, color: Color(0xFFDFE2E0),))
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                //height: MediaQuery.of(context).size.height /2,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  children: [
                    Image.network(book.imageUrl),
                    const SizedBox(height: 10,),
                    Text(book.title, style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,),
                    BlocBuilder<AuthorBloc, AuthorState>(builder: (context, state) {
                      if(state is AuthorLoading){
                        return const Expanded(child: CircularProgressIndicator());
                      }
                      if(state is AuthorLoaded){
                        Author? author = state.authors.firstWhere(
                              (author) => author.id == book.authodId,
                        );
                        return Text(
                          author.fullName,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: const Color(0xFFC7C7C7),
                              fontWeight: FontWeight.normal),);
                      }
                      else{
                        return const Text("Something went wrong");
                      }
                    },),
                  ],
                )
            ),
            const SizedBox(height: 10,),
            CustomTabInBook(book: book,),
          ],
        ),
      ),
    );
  }
}


