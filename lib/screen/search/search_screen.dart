import 'dart:async'; // Add this import for Timer

import 'package:e_book_app/model/models.dart';
import 'package:e_book_app/repository/book/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../widget/widget.dart';
import 'components/list_category_in_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedSearchOption = "Name of book"; // Default search option
  bool _hasSearched = false;
  List<Book> searchResults = [];
  late SearchBloc searchBloc;
  Timer? _debounce; // Add this Timer variable

  void _onSearchTextChanged(String newText) {
    if (_debounce?.isActive ?? false) _debounce?.cancel(); // Cancel the previous timer if it's still active
    _debounce = Timer(const Duration(milliseconds: 5), () { // Set the debounce duration
      setState(() {
        _hasSearched = false;
      });
      if(_selectedSearchOption == "Name of book"){
        searchBloc.add(LoadSearchByTitle(words: newText));
      }
      else if(_selectedSearchOption == "Author"){
        searchBloc.add(LoadSearchByAuthor(words: newText));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    searchBloc = SearchBloc(BookRepository());
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the debounce timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchBloc,
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
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if(state is SearchLoading){
                  return const Center(child: CircularProgressIndicator());
                }
                else if (state is SearchLoaded) {
                  if (state.searchedBook.isNotEmpty) {
                    _hasSearched = true;
                    searchResults = state.searchedBook;
                  }
                }
                else if(state is SearchFailure){
                  return const SizedBox();
                }
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
              },
            )
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
            backgroundColor:
            _selectedSearchOption == option ? Colors.white : Colors.grey,
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
