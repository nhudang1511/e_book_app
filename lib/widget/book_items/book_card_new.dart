import 'package:e_book_app/repository/category/category_repository.dart';
import 'package:e_book_app/screen/book_detail/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../repository/author/author_repository.dart';

class BookCard extends StatefulWidget {
  final Book book;
  late bool inLibrary;

  BookCard({super.key, required this.book, required this.inLibrary});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  AuthorBloc authorBloc = AuthorBloc(AuthorRepository());
  List<String> categoryNames = [];
  CategoryBloc categoryBloc = CategoryBloc(CategoryRepository());

  @override
  void initState() {
    super.initState();
    authorBloc.add(LoadedAuthor(widget.book.authodId ?? ''));
    categoryBloc.add(LoadCategory());
  }

  @override
  void dispose() {
    super.dispose();
    authorBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => authorBloc,),
        BlocProvider(create: (_) => categoryBloc)
      ],
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            BookDetailScreen.routeName,
            arguments: {'book': widget.book, 'inLibrary': widget.inLibrary},
          );
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CategoryLoaded) {
              if (widget.book.categoryId != null) {
                for (String categoryId in widget.book.categoryId!) {
                  Category? category = state.categories.firstWhere(
                        (cat) => cat.id == categoryId,
                  );
                  categoryNames.add(category.name ?? '');
                }
              }
            }
            return Container(
              width: MediaQuery.of(context).size.width - 20,
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF2A5B5),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.network(widget.book.imageUrl ?? '')),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(widget.book.title ?? '',
                                style:
                                Theme.of(context).textTheme.headlineSmall)),
                        Expanded(
                            flex: 1,
                            child: BlocBuilder<AuthorBloc, AuthorState>(
                              builder: (context, state) {
                                if (state is AuthorLoaded) {
                                  Author? author = state.author;
                                  return Text(author.fullName ?? '');
                                } else {
                                  return const Text('Somthing went wrong');
                                }
                              },
                            )),
                        widget.book.price.toString() == '0'
                            ? const Icon(Icons.money_off)
                            : Text('Coins: ${widget.book.price.toString()}'),
                        Row(
                          children: [
                            const Icon(Icons.menu_book),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(widget.book.language ?? '')
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
