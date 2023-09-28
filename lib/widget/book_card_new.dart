import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 132,
      width: (MediaQuery.of(context).size.width)/2.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF2A5B5),),
      child: Row(
        children: [
          Expanded(flex:2, child: Text('Đơn giản', style: Theme.of(context).textTheme.headlineMedium )),
          Expanded(flex:2, child: Text('Tạ Thu Ngân dịch')),
          Expanded(flex:3,child: Image.network('https://intamphuc.vn/wp-content/uploads/2023/06/mau-bia-sach-dep-2.jpg'))
        ],
      ),
    );
  }
}
