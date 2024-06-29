import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_banner/popup_banner.dart';
import 'package:share_plus/share_plus.dart';

import '../../blocs/blocs.dart';
import '../../config/shared_preferences.dart';
import '../../model/models.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:  Stack(
        children: [
          SizedBox(
            height: 186,
            child:  AppBar(
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:  const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      widget.book.imageUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              elevation: 0,
              toolbarHeight: 90,
            ),
          ),
          // widget.child,
          Container(
            margin: const EdgeInsets.only(top: 130),
            child:  SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              widget.book.imageUrl ?? '',
                              width: MediaQuery.of(context).size.width / 2,
                              height: 250,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showHideDotsPopup(widget.book.bookPreview ?? []);
                                },
                                child: const Icon(
                                  Icons.remove_red_eye_rounded,
                                  color: Color(0xFFDFE2E0),
                                ),
                              ),
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
                                                .add(LoadLibrary());
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
                                      bool isBookInLibrary = state.libraries.any(
                                              (b) =>
                                          b.bookId == widget.book.id &&
                                              b.userId == SharedService.getUserId());
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
                                      widget._timer =
                                          Timer(const Duration(seconds: 1), () {
                                            Navigator.of(context).pop();
                                          });
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomDialogNotice(
                                            title: Icons.downloading,
                                            content: 'Please log in to add',
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.bookmark_outlined,
                                        color: Color(0xFFDFE2E0))),
                              IconButton(
                                  onPressed: () {
                                    Share.share(
                                        'https://github.com/nhudang1511/e_book_app_frontend');
                                    //Share.share(widget.book.imageUrl ?? '');
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    color: Color(0xFFDFE2E0),
                                  )),
                            ],
                          ),
                        )
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
                    Text(
                      widget.book.authorName ?? '',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: const Color(0xFFC7C7C7),
                        fontWeight: FontWeight.normal,
                      ),
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
        ],
      ),
    );
  }
}
