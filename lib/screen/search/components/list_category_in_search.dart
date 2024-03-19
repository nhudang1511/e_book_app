import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../repository/category/category_repository.dart';
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
  CategoryBloc categoryBloc = CategoryBloc(CategoryRepository());

  @override
  void initState() {
    super.initState();
    categoryBloc.add(LoadCategory());
  }


  @override
  void dispose() {
    super.dispose();
    categoryBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => categoryBloc,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const SectionTitle(title: 'Genres: '),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryLoaded) {
                final List<Category> allCategories = state.categories
                    .where((element) => element.status == true)
                    .toList();
                return BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    if (state is BookLoaded) {
                      final List<Book> books = state.books
                          .where((element) => element.status == true)
                          .toList();
                      final List<Category> filteredCategories =
                      allCategories.where((category) {
                        // Check if any book has this category id
                        return books
                            .any((book) =>
                            book.categoryId!.contains(category.id));
                      }).toList();
                      if (filteredCategories.isNotEmpty) {
                        return Expanded(
                          child: GridView.count(
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
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return const Text('Something went wrong');
              }
            },
          ),
        ],
      ),
    );
  }
}
