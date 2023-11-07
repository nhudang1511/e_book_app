import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_banner/popup_banner.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
import 'components/custom_tab_in_book.dart';

class BookDetailScreen extends StatefulWidget {
  static const String routeName = '/book_detail';

  static Route route({required Book book, required bool inLibrary}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => BookDetailScreen(book: book, inLibrary: inLibrary));
  }
  final Book book;
  late bool inLibrary;
  BookDetailScreen({super.key, required this.book, required this.inLibrary});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
 late bool isBookmarked;
  void showHideDotsPopup(List<String> images) {
    PopupBanner(
      context: context,
      images: images,
      dotsAlignment: Alignment.bottomCenter,
      dotsColorActive: Colors.blue,
      dotsColorInactive: Colors.grey.withOpacity(0.5),
      autoSlide: false,
      useDots: false,
      onClick: (int) {  },
    ).show();
  }
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LibraryBloc>(context).add(LoadLibrary());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
          actions: [
            BlocBuilder<UserBloc,UserState>(
              builder: (context, state) {
                if(state is UserLoaded){
                  return IconButton(onPressed: (){
                    widget.inLibrary = !widget.inLibrary;
                    !widget.inLibrary? BlocProvider.of<LibraryBloc>(context).add(RemoveFromLibraryEvent(userId: state.user.id, bookId: widget.book.id))
                        : BlocProvider.of<LibraryBloc>(context).add(AddToLibraryEvent(userId: state.user.id, bookId: widget.book.id));
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: widget.inLibrary ? const Text('Added'): const Text('Removed'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Đóng"),
                              onPressed: () {
                                setState(() {
                                  BlocProvider.of<LibraryBloc>(context).add(LoadLibrary());
                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                    }, icon: Icon(Icons.bookmark_outlined, color: widget.inLibrary ? const Color(0xFF8C2EEE) : const Color(0xFFDFE2E0),));

                }
                else{
                  return IconButton(onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Vui lòng đăng nhập để thực hiện tính năng"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Đóng"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng hộp thoại
                              },
                            ),
                          ],
                        );
                      },);
                  },
                      icon: const Icon(Icons.bookmark_outlined, color: Color(0xFFDFE2E0)));
                }

              }
            ),
            IconButton(onPressed: (){}, icon: const Icon(Icons.share, color: Color(0xFFDFE2E0),)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.download, color: Color(0xFFDFE2E0),))
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  children: [
                    Stack(children: [
                      Image.network(widget.book.imageUrl),
                      Positioned(
                          bottom: 0,
                          height: 30,
                          width: MediaQuery.of(context).size.width/1.5,
                          child: InkWell(
                            onTap: () => showHideDotsPopup(widget.book.bookPreview),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.grey.withAlpha(90)),
                              padding: const EdgeInsets.only(right: 10),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.remove_red_eye_rounded, color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Text('Preview', style: TextStyle(color: Colors.white),)
                                ],
                              ),
                            ),
                          ))
                    ]),
                    const SizedBox(height: 10,),
                    Text(widget.book.title, style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,),
                    BlocBuilder<AuthorBloc, AuthorState>(builder: (context, state) {
                      if(state is AuthorLoading){
                        return const Expanded(child: CircularProgressIndicator());
                      }
                      if(state is AuthorLoaded){
                        Author? author = state.authors.firstWhere(
                              (author) => author.id == widget.book.authodId,
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
            CustomTabInBook(book: widget.book,),
          ],
        ),
      ),
    );
  }
}

