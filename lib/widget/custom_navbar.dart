import 'package:flutter/material.dart';

import '../screen/screen.dart';

class CustomNavBar extends StatefulWidget {
  final int initialIndex; // Sử dụng initialIndex thay vì selectedIndex
  CustomNavBar({Key? key, required this.initialIndex}) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0; // Biến để theo dõi selectedIndex

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Khởi tạo selectedIndex từ initialIndex
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/'); // Điều hướng đến trang "Home"
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/search'); // Điều hướng đến trang "Search"
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/library'); // Điều hướng đến trang "Library"
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile'); // Điều hướng đến trang "Profile"
            break;
        }
      },
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
}
