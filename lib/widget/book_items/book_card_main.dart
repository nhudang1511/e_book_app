import 'package:flutter/material.dart';

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
      child: Row(
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
                        Text(book.authodId, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Color(0xFFC7C7C7), fontWeight: FontWeight.normal),),
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
                  itemCount: book.categoryId.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFEB6097),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 2, right: 5),
                      child: Text(book.categoryId[index],
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
      ),
    );
  }
}