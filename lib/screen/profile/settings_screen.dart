import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        title: "Settings",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.nightlight,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Dark mode",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Switch(
                          value: true,
                          onChanged: (bool value) {},
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
