import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';

class BookCardMain extends StatelessWidget {
  final Book book;
  late bool inLibrary;
  BookCardMain({
    super.key, required this.book,  required this.inLibrary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/book_detail', arguments: book);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          if(state is CategoryLoading){
            return const Center(child: CircularProgressIndicator());
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
                const SizedBox(width: 5),
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
                                  return const Expanded(child: CircularProgressIndicator());
                                }
                                if(state is AuthorLoaded){
                                  Author? author = state.authors.firstWhere(
                                        (author) => author.id == book.authodId,
                                  );
                                  return Text(
                                    author.fullName,
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: const Color(0xFFC7C7C7),
                                        fontWeight: FontWeight.normal),);
                                }
                                else{
                                  return const Text("Something went wrong");
                                }
                                },
                              ),
                            ],
                          ),
                          BlocBuilder<UserBloc,UserState>(builder: (context, state) {
                            if(state is UserLoaded){
                              String uId = state.user.id;
                              return IconButton(
                                  onPressed: (){
                                    BlocProvider.of<LibraryBloc>(context).add(AddToLibraryEvent(userId: state.user.id, bookId: book.id));
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Thêm vào thư viện thành công"),
                                          content: Text("Cuốn sách đã được thêm vào thư viện của bạn."),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Đóng"),
                                              onPressed: () {
                                                BlocProvider.of<LibraryBloc>(context).add(LoadLibrary());
                                                Navigator.of(context).pop(); // Đóng hộp thoại
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
                                    if(state is LibraryLoaded){
                                      bool isBookInLibrary = state.libraries.any((b) =>b.userId == uId && b.bookId == book.id);
                                      if (isBookInLibrary) {
                                        inLibrary = true; // Nếu sách có trong Books, đặt inLibrary thành true
                                      }
                                    }
                                    return Icon(Icons.bookmark_outlined,color: inLibrary ? const Color(0xFF8C2EEE) : const Color(0xFFDFE2E0),);
                                  },
                                  )); }
                            else{
                              return const Icon(Icons.bookmark_outlined,color: Color(0xFFDFE2E0),);
                            }
                          }
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 35,),
                    const Icon(Icons.money_off),
                    Row(children: [
                      const Icon(Icons.menu_book),
                      const SizedBox(width: 5,),
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
                                  color: const Color(0xFFEB6097),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(top: 2, right: 5),
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
            return const Text("Something went wrong");
          }
  },
),
      ),
    );
  }
}