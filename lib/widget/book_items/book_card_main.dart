import 'dart:async';
import 'package:e_book_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../config/shared_preferences.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
import '../../utils/show_snack_bar.dart';

class BookCardMain extends StatefulWidget {
  final Book book;
  bool inLibrary;

  BookCardMain({super.key, required this.book, required this.inLibrary});

  @override
  State<BookCardMain> createState() => _BookCardMainState();
}

class _BookCardMainState extends State<BookCardMain> {
  late Timer _timer;
  late AudioBloc audioBloc;
  bool haveAudio = false;
  late ChaptersBloc chaptersBloc;
  bool haveReading = false;

  @override
  void initState() {
    super.initState();
    audioBloc = AudioBloc(AudioRepository())
      ..add(LoadAudio(widget.book.id ?? ''));
    chaptersBloc = ChaptersBloc(ChaptersRepository())
      ..add(LoadChapters(widget.book.id ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => audioBloc),
        BlocProvider(create: (context) => chaptersBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AudioBloc, AudioState>(listener: (context, state) {
            if (state is AudioLoaded) {
              setState(() {
                haveAudio = true;
              });
            }
          }),
          BlocListener<ChaptersBloc, ChaptersState>(listener: (context, state) {
            if (state is ChaptersLoaded) {
              setState(() {
                haveReading = true;
              });
            }
          }),
        ],
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              BookDetailScreen.routeName,
              arguments: {'book': widget.book, 'inLibrary': widget.inLibrary},
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height /5 + 20,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Image.network(
                      widget.book.imageUrl ?? '',
                      height: 190,
                      width: MediaQuery.of(context).size.width/2,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(width: 10),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.book.title ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      widget.book.authorName ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: const Color(0xFFC7C7C7),
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state is AuthenticateState) {
                                    return IconButton(onPressed: () {
                                      widget.inLibrary = !widget.inLibrary;
                                      !widget.inLibrary
                                          ? BlocProvider.of<LibraryBloc>(
                                                  context)
                                              .add(RemoveFromLibraryEvent(
                                                  userId: SharedService
                                                          .getUserId() ??
                                                      '',
                                                  bookId: widget.book.id ?? ''))
                                          : BlocProvider.of<LibraryBloc>(
                                                  context)
                                              .add(AddToLibraryEvent(
                                                  userId: SharedService
                                                          .getUserId() ??
                                                      '',
                                                  bookId:
                                                      widget.book.id ?? ''));
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          _timer = Timer(
                                              const Duration(seconds: 1), () {
                                            BlocProvider.of<LibraryBloc>(
                                                    context)
                                                .add(LoadLibrary());
                                            Navigator.of(context).pop();
                                          });
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ).then((value) {
                                        if (_timer.isActive) {
                                          _timer.cancel();
                                        }
                                      });
                                    }, icon:
                                        BlocBuilder<LibraryBloc, LibraryState>(
                                      builder: (context, state) {
                                        if (state is LibraryLoaded) {
                                          bool isBookInLibrary = state.libraries
                                              .any((b) =>
                                                  b.bookId == widget.book.id &&
                                                  b.userId ==
                                                      SharedService
                                                          .getUserId());
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
                                    ));
                                  } else {
                                    return IconButton(
                                        onPressed: () {
                                          ShowSnackBar.error(
                                              "Please log in to add",
                                              context);
                                        },
                                        icon: const Icon(
                                            Icons.bookmark_outlined,
                                            color: Color(0xFFDFE2E0)));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                widget.book.price.toString() == '0'
                                    ? const Icon(Icons.money_off)
                                    : Text(
                                        'Coins: ${widget.book.price.toString()}'),
                                if (haveReading)
                                  const Row(
                                    children: [
                                      Icon(Icons.menu_book),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Ebook')
                                    ],
                                  ),
                                if (haveAudio)
                                  const Row(
                                    children: [
                                      Icon(Icons.headphones),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Audiobook')
                                    ],
                                  ),
                                SizedBox(
                                  height: 25,
                                  child: ListView.builder(
                                      itemCount:
                                          widget.book.categoryName?.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final colors = [
                                              const Color(0xFFEB6097),
                                              const Color(0xFF6A1CBD),
                                              const Color(0xFFFDC844)
                                            ];
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: colors[index%3],
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.only(
                                              top: 2, right: 5),
                                          child: Text(
                                            widget.book.categoryName![index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: Colors.white),
                                          ),
                                        );
                                      }),
                                )
                              ]),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
