import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final String screen;
  final void Function(int) onTabSelected;

  const CustomNavBar({
    Key? key,
    required this.screen,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      backgroundColor: Theme.of(context).colorScheme.background,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      currentIndex: _getSelectedIndex(widget.screen),
      onTap: widget.onTabSelected,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_rounded),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getSelectedIndex(String screen) {
    switch (screen) {
      case 'home':
        return 0;
      case 'search':
        return 1;
      case 'library':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }
}
