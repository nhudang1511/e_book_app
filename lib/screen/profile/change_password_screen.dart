import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
  static const String routeName = '/change_password';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ChangePasswordScreen(),
    );
  }
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(title: "Change Password",),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: currentHeight,
            child: Column(
              children: <Widget>[
                const CustomTextField(hint: "Old Password"),
                Padding(
                  padding: const EdgeInsets.only(right: 32, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SelectableText(
                        "Forgot Password?",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomTextField(hint: "New Password"),
                const CustomTextField(hint: "Confirm New Password"),
                const SizedBox(
                  height: 32,
                ),
                CustomButton(title: "Update", onPressed: (){})
              ],
            ),
          ),
        ),
      ),
    );
  }

}