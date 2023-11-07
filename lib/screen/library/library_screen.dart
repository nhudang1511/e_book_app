import 'package:e_book_app/blocs/auth/auth_bloc.dart';
import 'package:e_book_app/model/library_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../widget/book_items/list_book_main.dart';
import '../../widget/widget.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  static const String routeName = '/library';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const LibraryScreen());
  }
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState(){
    super.initState();
    //BlocProvider.of<LibraryBloc>(context).add(LoadLibrary());
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
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (context, state) {
        return state is AuthInitial || state is UnAuthenticateState;
      },
      listener: (context, state) {
        Navigator.pushNamed(context, "/login");
      },
      builder: (context, state) {
        if(state is AuthenticateState){
          final String uId = state.authUser.uid;
          return DefaultTabController(
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
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
                    Expanded(
                      child: TabBarView(
                        children: [
                          CollectionTab(),
                          FavouritesTab(uId: uId),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        else{
          return Text('');
        }
      }
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
  const FavouritesTab({super.key, required this.uId});
  final String uId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if(state is LibraryLoaded){
                  List<Library> libraries = state.libraries.where((element) => element.userId == uId ).toList();
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
                            height: MediaQuery.of(context).size.height-50,
                            inLibrary: true
                          );
                        } else {
                          return const Text('No matching books found');
                        }
                      }
                      else{
                        return const CircularProgressIndicator();
                      }
                      },
                  );
                }
                else{
                  return const CircularProgressIndicator();
                }},)
        ),
      ),
    );
  }
}
