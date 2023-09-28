import 'package:flutter/material.dart';

class BookCardMain extends StatelessWidget {
  const BookCardMain({
    super.key,
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
              child: Image.network('https://sachxuasaigon.com/wp-content/uploads/2020/01/De-men-phieu-luu-ky-1.jpg')),
          Expanded(flex:2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dế mèn phiêu lưu ký', style: Theme.of(context).textTheme.headlineSmall,),
                      Text('Tô Hoài', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Color(0xFFC7C7C7), fontWeight: FontWeight.normal),),
                    ],
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_outlined, color: Color(0xFFDFE2E0),))
                ],
              ),
              SizedBox(height: 35,),
              Icon(Icons.money_off),
              Row(children: [
                Icon(Icons.menu_book),
                SizedBox(width: 5,),
                Text('204 pages')
              ],),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFEB6097),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 2),
                      child: Text('Fairy tail', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),))
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}