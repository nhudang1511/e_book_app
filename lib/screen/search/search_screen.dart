import 'package:e_book_app/model/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../repository/repository.dart';
import '../../widget/widget.dart';
import 'components/list_category_in_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SearchScreen());
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = "";
  String _selectedSearchOption = "Name of book"; // Default search option
  bool _hasSearched = false;

  void _onSearchTextChanged(String newText) {
    setState(() {
      _searchText = newText;
      _hasSearched = false;
    });
  }

  List<Book> _performSearch(List<Book> books, List<Author> authors) {
    List<Book> results = [];
    if (_searchText.isEmpty) {
      return results;
    }
    if (_selectedSearchOption == "Name of book") {
      results = books
          .where((book) =>
              book.title!.toLowerCase().contains(_searchText.toLowerCase()) &&
              book.status == true)
          .toList();
    } else if (_selectedSearchOption == "Author") {
      results = books.where((book) {
        // Tìm tác giả dựa trên fullName
        Author? author = authors.firstWhere(
            (author) => author.id?.toLowerCase() == book.authodId?.toLowerCase());
        return author.fullName
            !.toLowerCase()
            .contains(_searchText.toLowerCase());
      }).toList();
    }
    // else if (_selectedSearchOption == "Tags") {
    //   results = books
    //       .where((book) => book.categoryId.contains(_searchText.toLowerCase()))
    //       .toList();
    // }
    _hasSearched = true;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthorBloc(AuthorRepository(),
            )..add(LoadedAuthor())),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(title: 'Search'),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFC7C7C7)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          onChanged: _onSearchTextChanged,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for book',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: const Color(0xFFC9C9C9)),
                          ),
                        ),
                      ),
                      // const Icon(Icons.mic)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  _buildSearchOptionButton("Name of book"),
                  _buildSearchOptionButton("Author"),
                  // _buildSearchOptionButton("Tags"),
                ],
              ),
            ),
            BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is BookLoaded) {
                  List<Book> book = state.books
                      .where((element) => element.status == true)
                      .toList();
                  return BlocBuilder<AuthorBloc, AuthorState>(
                    builder: (context, state) {
                      if (state is AuthorLoaded) {
                        List<Book> searchResults =
                            _performSearch(book, state.authors);
                        return Expanded(
                          child: _hasSearched == true
                              ? SizedBox(
                                  height: 180,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: searchResults.length,
                                      itemBuilder: (context, index) {
                                        return BookCardMain(
                                          book: searchResults[index],
                                          inLibrary: false,
                                        );
                                      }),
                                )
                              : const ListCategoryInSearch(),
                        );
                      } else {
                        return const Text('Something went wrong');
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
      ),
    );
  }

  Widget _buildSearchOptionButton(String option) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedSearchOption = option;
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: _selectedSearchOption == option ? Colors.white : Colors.grey,
            side: _selectedSearchOption == option
                ? BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.primary)
                : null),
        child: Text(
          option,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
