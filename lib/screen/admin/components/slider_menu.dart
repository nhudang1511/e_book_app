import 'package:flutter/material.dart';

class SliderMenu extends StatelessWidget {
  const SliderMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF601DB2),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(child: Image.asset('assets/logo/logo.png')),
            DrawerListTile(title: 'Dashboard',icons: Icons.dashboard_rounded,press: (){},),
            DrawerListTile(title: 'Categories',icons: Icons.category_rounded,press: (){},),
            DrawerListTile(title: 'Books',icons: Icons.library_books_rounded,press: (){},),
            DrawerListTile(title: 'Users',icons: Icons.person,press: (){},)
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icons,
    required this.press
  });

  final String title;
  final IconData icons;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icons, color: Colors.white54,),
      title: Text(title, style: const TextStyle(color: Colors.white54)),
    );
  }
}