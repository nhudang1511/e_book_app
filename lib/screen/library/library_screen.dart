import 'package:flutter/material.dart';

import '../../widget/widget.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const String routeName = '/library';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const LibraryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'My library'),
      bottomNavigationBar: CustomNavBar(screen: 'library',),
    );
  }
}