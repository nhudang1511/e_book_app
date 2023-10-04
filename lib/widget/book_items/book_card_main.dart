import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';

class BookCardMain extends StatelessWidget {
  final Book book;
  const BookCardMain({
    super.key, required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
        if(state is CategoryLoading){
          return Center(child: CircularProgressIndicator());
        }
        if(state is CategoryLoaded){
          // Tạo danh sách tên danh mục từ categoryId trong book
          List<String> categoryNames = [];
          for (String categoryId in book.categoryId) {
            Category? category = state.categories.firstWhere(
                  (cat) => cat.id == categoryId,
            );
            if (category != null) {
              categoryNames.add(category.name);
            }
          }
          return Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Image.network(book.imageUrl)),
              SizedBox(width: 5),
              Expanded(flex:2, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.title, style: Theme.of(context).textTheme.headlineSmall,),
                            BlocBuilder<AuthorBloc, AuthorState>(builder: (context, state) {
                              if(state is AuthorLoading){
                                return Expanded(child: CircularProgressIndicator());
                              }
                              if(state is AuthorLoaded){
                                Author? author = state.authors.firstWhere(
                                      (author) => author.id == book.authodId,
                                );
                                return Text(
                                  author.fullName,
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      color: Color(0xFFC7C7C7),
                                      fontWeight: FontWeight.normal),);
                              }
                              else{
                                return Text("Something went wrong");
                              }
                              },
                            ),
                          ],
                        ),
                        IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_outlined, color: Color(0xFFDFE2E0),))
                      ],
                    ),
                  ),
                  SizedBox(height: 35,),
                  Icon(Icons.money_off),
                  Row(children: [
                    Icon(Icons.menu_book),
                    SizedBox(width: 5,),
                    Text(book.language)
                  ],),
                  SizedBox(
                    height: 25,
                    child: ListView.builder(
                        itemCount: categoryNames.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFEB6097),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 2, right: 5),
                            child: Text(categoryNames[index],
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          );
                        }),
                  )
                ],
              ))
            ],
          );
        }
        else{
          return Text("Something went wrong");
        }
  },
),
    );
  }
}