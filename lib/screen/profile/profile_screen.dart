import 'package:flutter/material.dart';

import '../../widget/widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Các thành phần khác ở đây

            // Nút đăng nhập
            ElevatedButton(
              onPressed: null,
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}