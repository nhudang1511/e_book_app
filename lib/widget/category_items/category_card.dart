import 'package:flutter/material.dart';
import '../../model/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/category', arguments: category);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.all(5),
        height: 132,
        width: (MediaQuery.of(context).size.width)/2.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF8C2EEE),),
        child: Row(
          children: [
            Expanded(
                flex:1,
                child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white) )),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5),
              ),
              child: SizedBox(
                height: 80,
                width: 80,
                child: ClipOval(
                    child: Image.network(category.imageUrl, fit: BoxFit.cover,)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
