import 'package:e_book_app/screen/admin/components/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'components/slider_menu.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  static const String routeName = '/admin_panel';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const AdminPanel());
  }

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                child: SliderMenu()
            ),
            Expanded(
                flex: 4,
                child: DashboardScreen())
          ],
        ),
      ),
    );
  }
}

