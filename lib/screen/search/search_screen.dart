import 'package:e_book_app/model/models.dart';
import 'package:e_book_app/widget/category_items/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../widget/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SearchScreen());
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Search'),
      //bottomNavigationBar: CustomNavBar(initialIndex: 1,),
      body: Column(
        children: [
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFDFE2E0)
                    //border: Border.all(color: Colors.grey), // Đổi màu viền nếu cần
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onTap: () {
                            controller.openView();
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search...',
                            hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: Color(0xFFC9C9C9))
                          ),
                        ),
                      ),
                      Icon(Icons.mic),
                    ],
                  ),
                ),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            },
          ),
          SizedBox(height: 10),
          SectionTitle(title: 'Genres: '),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if(state is CategoryLoading){
                return Center(child: CircularProgressIndicator());
              }
              if(state is CategoryLoaded){
                return Expanded(
                  child: GridView.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(state.categories.length, (index) {
                      return CategoryCard(category: state.categories[index]);
                    }),
                  ),
                );
              }
              else{
                return Text('Something went wrong');
              }},
          ),
        ],
      )
    );
  }
}