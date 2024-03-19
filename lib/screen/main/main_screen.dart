import 'package:e_book_app/screen/screen.dart';
import 'package:flutter/material.dart';
import '../../../widget/widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static const String routeName = '/';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;


  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: _buildPage(_currentIndex),
      ),
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onTabSelected,
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const LibraryScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const MainScreen();
    }
  }
}