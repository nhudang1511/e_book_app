import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget{
  final String screen;
  const CustomNavBar({
    super.key, required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.background,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/');
                },
                icon: Icon(
                    Icons.home,
                    color: screen == 'home' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary )),
            IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/search');
                },
                icon: Icon(
                    Icons.search,
                    color:  screen == 'search' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary)),
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/library');
              },
              icon: Icon(
                  Icons.library_books_rounded,
                  color:  screen == 'library' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary),),
            IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/profile');
                },
                icon: Icon(
                    Icons.person,
                    color:  screen == 'profile' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary))
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.0);
}