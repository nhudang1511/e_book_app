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
    return const Scaffold(
      appBar: CustomAppBar(title: 'Search'),
    );
  }
}