import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../widget/widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '/category';
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Book> listBookInCategory = [];

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
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.category.name ?? '',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: ClipOval(
                    child: Image.network(
                  widget.category.imageUrl ?? '',
                  fit: BoxFit.cover,
                )),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BookLoaded) {
                  listBookInCategory = state.books
                      .where(
                          (element) => element.categoryId!.contains(widget.category.id))
                      .toList();
                }
                return listBookInCategory.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: listBookInCategory.length,
                            itemBuilder: (context, index) {
                              return BookCardMain(
                                  book: listBookInCategory[index],
                                  inLibrary: false);
                            }),
                      )
                    : const Center(
                        child: Text('No data'),
                      );
              },
            ),
          ],
        ));
  }
}
