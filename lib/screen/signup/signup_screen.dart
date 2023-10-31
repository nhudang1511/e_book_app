import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  const SignupScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SignupScreen(),
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
                  child:
                      const Image(image: AssetImage('assets/logo/logo1.png')),
                ),
                //Gets tart
                const Column(
                  children: [
                    CustomTitle(title1: "Get", title2: "started"),
                    //with email
                    CustomSecondaryTitle(title: "With email")
                  ],
                ),
                const Column(
                  children: [
                    //email input
                    CustomTextField(hint: "Email"),
                    //password input
                    PasswordInput(hint: "Password"),
                    //confirm pass input
                    PasswordInput(hint: "Confirm password"),
                  ],
                ),
                //signup button
                CustomButton(
                  title: "Sign up",
                  onPressed: () {
                    print('Nút tùy chỉnh đã được nhấn');
                  },
                ),
                //already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have a account? ",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SelectableText(
                      "Log in",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
