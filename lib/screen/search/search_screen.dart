import 'package:flutter/material.dart';

import '../../widget/widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SearchScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Search'),
      bottomNavigationBar: CustomNavBar(screen: 'search',   onTabSelected: (index) {
        // Xử lý sự kiện chọn tab ở đây
        if (index == 1) {
          // Điều hướng đến màn hình Search
          Navigator.pushReplacementNamed(context, '/search');
        } else if (index == 2) {
          // Điều hướng đến màn hình Library
          Navigator.pushReplacementNamed(context, '/library');
        } else if (index == 3) {
          // Điều hướng đến màn hình Profile
          Navigator.pushReplacementNamed(context, '/profile');
        }
      },),
    );
  }
}