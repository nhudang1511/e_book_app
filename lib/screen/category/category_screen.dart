import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';
import '../../widget/widget.dart';

class CategoryScreen extends StatelessWidget {
  static const String routeName = '/category';

  static Route route({required Category category}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => CategoryScreen(category: category,));
  }
  final Category category;
  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.name, style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(width: 10,),
            SizedBox(
              height: 50,
              width: 50,
              child: ClipOval(
                  child: Image.network(category.imageUrl, fit: BoxFit.cover,)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<BookBloc, BookState>(builder: (context, state) {
            if(state is BookLoading){
              return const Center(child: CircularProgressIndicator());
            }
            if(state is BookLoaded){
              final listBookInCategory = state.books.where((e) => e.categoryId.contains(category.id)).toList();
              if(listBookInCategory.isNotEmpty){
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listBookInCategory.length,
                      itemBuilder: (context,index){
                        return BookCardMain(book: listBookInCategory[index], inLibrary: false,);
                      }),
                );
              }
              else{
                return const Center(child: Text('No data'),);
              }
            }
            else{
              return const Text('Something went wrong');
            }
  },
),
        ],
      )
    );
  }
}