import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const CustomAppBar({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      title: Text( title,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      //titleSpacing: -40,
      centerTitle: false,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50.0);
}


