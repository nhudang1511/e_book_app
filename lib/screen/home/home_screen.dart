import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_book_app/widget/book_items/list_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../widget/widget.dart';
import '../library/components/histories_tab.dart';
import 'components/custom_appbar_home.dart';
import 'components/list_quote.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<Book> books = [];
  List<Book> newBooks = [];
  List<Book> recommendBooks = [];
  Author author = Author();
  final List<Widget> imageSliders = listQuote
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: item.color, borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      child: Image.asset(item.imageUrl, fit: BoxFit.fill)),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.quote,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ))
      .toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    String period = getDayPeriod(now);
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BookLoaded) {
          //print(state.books.length);
          books = state.books;
          newBooks.clear();
          for (var b in books) {
            DateTime currentDate = DateTime.now();
            // Trừ 3 ngày từ ngày hiện tại
            DateTime dateBeforeThreeDays =
                currentDate.subtract(const Duration(days: 3));
            if (b.createAt!.isAfter(dateBeforeThreeDays) ||
                b.updateAt!.isAfter(dateBeforeThreeDays)) {
              newBooks.add(b);
            }
          }
        }
        return CustomScrollView(
          slivers: <Widget>[
            CustomAppBarHome(title: period),
            // const SectionTitle(title: 'New reals'),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      items: imageSliders,
                      carouselController: _controller,
                      options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listQuote.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (newBooks.isNotEmpty)
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  const SectionTitle(title: 'New reals'),
                  SizedBox(
                    height: 150,
                    child: ListBook(
                      books: newBooks,
                      inLibrary: false,
                    ),
                  ),
                ],
              )),
            SliverToBoxAdapter(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthenticateState) {
                    return Column(
                      children: [
                        DisplayHistories(
                          uId: state.authUser?.uid,
                          scrollDirection: Axis.horizontal,
                          height: 180,
                          inHistory: true,
                          book: books,
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Column(
                  children: [
                    const SectionTitle(title: 'All Books'),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: books.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BookCardMain(
                            book: books[index],
                            inLibrary: false,
                          );
                        }),
                  ],
                );
              }, childCount: 1),
            ),
          ],
        );
      },
    );
  }

  String getDayPeriod(TimeOfDay time) {
    if (time.hour < 12) {
      return 'Good morning!';
    } else if (time.hour < 18) {
      return 'Good afternoon!';
    } else {
      return 'Good evening!';
    }
  }
}
