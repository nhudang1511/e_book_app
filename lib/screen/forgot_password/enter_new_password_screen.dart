import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class EnterNewPasswordScreen extends StatelessWidget {
  static const String routeName = "/enter_new_password";

  const EnterNewPasswordScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EnterNewPasswordScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: currentHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //logo
                SizedBox(
                  height: currentHeight / 4,
                  child: const Image(
                    image: AssetImage("assets/logo/logo1.png"),
                  ),
                ),
                const CustomTitle(title1: "Enter", title2: "new password"),
                const Column(
                  children: [
                    PasswordInput(hint: "New password"),
                    PasswordInput(hint: "Confirm new password"),
                  ],
                ),
                //confirm button
                CustomButton(
                  title: "Confirm",
                  onPressed: () {
                    print('Nút tùy chỉnh đã được nhấn');
                  },
                ),
                SizedBox(
                  height: currentHeight / 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
