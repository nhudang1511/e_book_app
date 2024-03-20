import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_banner/popup_banner.dart';
import 'package:share_plus/share_plus.dart';

import '../../blocs/blocs.dart';
import '../../config/shared_preferences.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
import '../../widget/custom_dialog_notice.dart';
import 'components/custom_tab_in_book.dart';

class BookDetailScreen extends StatefulWidget {
  static const String routeName = '/book_detail';
  final Book book;
  late bool inLibrary;
  late Timer _timer;

  BookDetailScreen({super.key, required this.book, required this.inLibrary});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late bool isBookmarked;
  String uId = SharedService.getUserId() ?? '';

  void showHideDotsPopup(List<String> images) {
    PopupBanner(
      context: context,
      images: images,
      dotsAlignment: Alignment.bottomCenter,
      dotsColorActive: Colors.blue,
      dotsColorInactive: Colors.grey.withOpacity(0.5),
      autoSlide: false,
      useDots: false,
      onClick: (e) {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthorBloc(
              AuthorRepository(),
            )..add(LoadedAuthor(widget.book.authodId ?? ''))),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
            actions: [
              if (uId != '')
                IconButton(onPressed: () {
                  widget.inLibrary = !widget.inLibrary;
                  !widget.inLibrary
                      ? BlocProvider.of<LibraryBloc>(context).add(
                      RemoveFromLibraryEvent(
                          userId: uId,
                          bookId: widget.book.id ?? ''))
                      : BlocProvider.of<LibraryBloc>(context).add(
                      AddToLibraryEvent(
                          userId: uId,
                          bookId: widget.book.id ?? ''));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      widget._timer =
                          Timer(const Duration(seconds: 1), () {
                            BlocProvider.of<LibraryBloc>(context)
                                .add(LoadLibraryByUid(uId));
                            Navigator.of(context).pop();
                          });
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ).then((value) {
                    if (widget._timer.isActive) {
                      widget._timer.cancel();
                    }
                  });
                }, icon: BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                    if (state is LibraryLoaded) {
                      bool isBookInLibrary = state.libraries.any((b) =>
                      b.bookId == widget.book.id);
                      if (isBookInLibrary) {
                        widget.inLibrary =
                        true; // Nếu sách có trong Library, đặt inLibrary thành true
                      }
                    }
                    return Icon(
                      Icons.bookmark_outlined,
                      color: widget.inLibrary
                          ? const Color(0xFF8C2EEE)
                          : const Color(0xFFDFE2E0),
                    );
                  },
                ))
              else
                IconButton(
                    onPressed: () {
                      widget._timer = Timer(
                          const Duration(seconds: 1),
                              () {
                            Navigator.of(context).pop();
                          });
                      showDialog(
                        context: context,
                        builder:
                            (BuildContext context) {
                          return const CustomDialogNotice(
                            title: Icons.downloading,
                            content:
                            'Please log in to add',
                          );
                        },
                      );
                    },
                    icon: const Icon(
                        Icons.bookmark_outlined,
                        color: Color(0xFFDFE2E0))),
              IconButton(
                  onPressed: () {
                    // Share.share(
                    //     'https://web.facebook.com/profile.php?id=100017418181405');
                    Share.share(widget.book.imageUrl ?? '');
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Color(0xFFDFE2E0),
                  )),
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.download,
              //       color: Color(0xFFDFE2E0),
              //     ))
            ]),
        body: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      widget.book.imageUrl ?? '',
                      width: MediaQuery.of(context).size.width / 2,
                      height: 250,
                    ),
                    Positioned(
                      bottom: 0,
                      height: 30,
                      width: MediaQuery.of(context).size.width / 2,
                      child: InkWell(
                        onTap: () => showHideDotsPopup(widget.book.bookPreview ?? []),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey.withAlpha(90)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_red_eye_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Preview',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.book.title ?? '',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                BlocBuilder<AuthorBloc, AuthorState>(
                  builder: (context, state) {
                    if (state is AuthorLoaded) {
                      Author? author = state.author;
                      return Text(
                        author.fullName ?? '',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: const Color(0xFFC7C7C7),
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    } else {
                      return const Text("Something went wrong");
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTabInBook(
                  book: widget.book,
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
