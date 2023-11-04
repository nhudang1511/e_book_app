import 'package:e_book_app/blocs/auth/auth_bloc.dart';
import 'package:e_book_app/model/library_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/book/book_bloc.dart';
import '../../blocs/library/library_bloc.dart';
import '../../model/book_model.dart';
import '../../widget/book_items/list_book_main.dart';
import '../../widget/widget.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const String routeName = '/library';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const LibraryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'My library'),
      body: CustomTab(),
    );
  }
}

// Tab bar
class CustomTab extends StatefulWidget {
  const CustomTab({super.key});

  @override
  State<StatefulWidget> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (context, state) {
        return state is AuthInitial || state is UnAuthenticateState;
      },
      listener: (context, state) {
        Navigator.pushNamed(context, "/login");
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: null,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                    tabs: const [
                      Tab(
                        text: 'Collection',
                      ),
                      Tab(
                        text: 'Favourites',
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      CollectionTab(),
                      FavouritesTab(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollectionTab extends StatelessWidget {
  const CollectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('hello')),
    );
  }
}
class FavouritesTab extends StatelessWidget {
  const FavouritesTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, state) {
              if(state is LibraryLoading){
                return const Text('Loading');
              }
              else if(state is LibraryLoaded){
                List<Library> libraries = state.libraries;
                return BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    if(state is BookLoaded){
                      List<Book> matchingBooks = state.books
                          .where((book) =>
                          libraries.any((library) =>
                          library.bookId == book.id))
                          .toList();
                      if (matchingBooks.isNotEmpty) {
                        return ListBookMain(
                          books: matchingBooks,
                          scrollDirection: Axis.vertical,
                          height: MediaQuery.of(context).size.height-50,);
                      } else {
                        return const Text('No matching books found');
                      }
                    }
                    else{
                      return const Text('Something went wrong in Book');
                    }
                    },
                );
              }
              else{
                return const Text('Something went wrong in Library');
              }
  },
)),
    );
  }
}
