import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/category/category_bloc.dart';
import '../../../widget/category_items/category_card.dart';
import '../../../widget/widget.dart';

class ListCategoryInSearch extends StatelessWidget {
  const ListCategoryInSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}