import 'dart:async';

import 'package:e_book_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../config/shared_preferences.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
import '../widget.dart';

class BookCardMain extends StatefulWidget {
  final Book book;
  bool inLibrary;

  BookCardMain({
    super.key,
    required this.book,
    required this.inLibrary,
  });

  @override
  State<BookCardMain> createState() => _BookCardMainState();
}

class _BookCardMainState extends State<BookCardMain> {
  late Timer _timer;
  String uId = SharedService.getUserId() ?? '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthorBloc(
                  AuthorRepository(),
                )..add(LoadedAuthor(widget.book.authodId ?? ''))),
        BlocProvider(
            create: (_) => CategoryBloc(
                  CategoryRepository(),
                )..add(LoadCategory())),
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
          height: 150,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryLoaded) {
                // Tạo danh sách tên danh mục từ categoryId trong book
                List<String> categoryNames = [];
                if (widget.book.categoryId != null) {
                  for (String categoryId in widget.book.categoryId!) {
                    Category? category = state.categories.firstWhere(
                      (cat) => cat.id == categoryId,
                    );
                    categoryNames.add(category.name ?? '');
                  }
                }
                return Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Image.network(widget.book.imageUrl ?? '')),
                    const SizedBox(width: 5),
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.book.title ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        BlocBuilder<AuthorBloc, AuthorState>(
                                          builder: (context, state) {
                                            if (state is AuthorLoading) {
                                              return const Expanded(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                            if (state is AuthorLoaded) {
                                              Author? author =
                                                  state.author;
                                              return Text(
                                                maxLines: 2,
                                                author.fullName ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                        color: const Color(
                                                            0xFFC7C7C7),
                                                        fontWeight:
                                                            FontWeight.normal),
                                              );
                                            } else {
                                              return const Text(
                                                  "Something went wrong");
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (uId != '')
                                    IconButton(onPressed: () {
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
                                                .add(LoadLibraryByUid(uId));
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
                                          _timer = Timer(
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
                                            color: Color(0xFFDFE2E0)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.money_off),
                                    Row(
                                      children: [
                                        const Icon(Icons.menu_book),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(widget.book.language ?? '')
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                      child: ListView.builder(
                                          itemCount: categoryNames.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFEB6097),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: const EdgeInsets.all(5),
                                              margin: const EdgeInsets.only(
                                                  top: 2, right: 5),
                                              child: Text(
                                                categoryNames[index],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            );
                                          }),
                                    )
                                  ]),
                            ),
                          ],
                        ))
                  ],
                );
              } else {
                return const Text("Something went wrong");
              }
            },
          ),
        ),
      ),
    );
  }
}
