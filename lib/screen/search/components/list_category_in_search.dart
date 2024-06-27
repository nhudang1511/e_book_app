import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../widget/category_items/category_card.dart';
import '../../../widget/widget.dart';

class ListCategoryInSearch extends StatefulWidget {
  const ListCategoryInSearch({
    super.key,
  });

  @override
  State<ListCategoryInSearch> createState() => _ListCategoryInSearchState();
}

class _ListCategoryInSearchState extends State<ListCategoryInSearch> {

  ScrollController controller = ScrollController();
  bool isPaginating = false;
  List<Category> filteredCategories = [];

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      isPaginating = true;
      context.read<BookBloc>().add(LoadBooksPaginating());
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const SectionTitle(title: 'Genres: '),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CategoryLoaded) {
              final List<Category> allCategories = state.categories;
              return BlocBuilder<BookBloc, BookState>(
                builder: (context, state) {
                  if (state is BookLoaded) {
                    isPaginating = false;
                    final List<Book> books = state.books;
                    filteredCategories =
                    allCategories.where((category) {
                      // Check if any book has this category id
                      return books
                          .any((book) =>
                          book.categoryId!.contains(category.id));
                    }).toList();
                    if(state.lastDoc != null && filteredCategories.length <= 6){
                      isPaginating = true;
                      context.read<BookBloc>().add(LoadBooksPaginating());
                    }
                  }
                  return Expanded(
                    child: GridView.count(
                      controller: controller,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      // Generate 100 widgets that display their index in the List.
                      children:
                      List.generate(filteredCategories.length, (index) {
                        return CategoryCard(
                            category: filteredCategories[index]);
                      }),
                    ),
                  );
                },
              );
            } else {
              return const Text('Something went wrong');
            }
          },
        ),
        isPaginating
            ? Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: const Center(
              child: CircularProgressIndicator(),
            ))
            : const SizedBox()
      ],
    );
  }
}
