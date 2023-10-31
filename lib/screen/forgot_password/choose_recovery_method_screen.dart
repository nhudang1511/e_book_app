import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class ChooseRecoveryMethodScreen extends StatelessWidget {
  static const String routeName = "/choose_recovery_method";

  const ChooseRecoveryMethodScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ChooseRecoveryMethodScreen(),
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
                const Column(
                  children: [
                    //forget password
                    CustomTitle(title1: "Forget", title2: "password"),
                    //choose
                    CustomSecondaryTitle(
                        title: "Choose a password recovery method")
                  ],
                ),
                Column(
                  children: [
                    CustomButton(
                      title: "Email",
                      onPressed: () {
                        print('Nút tùy chỉnh đã được nhấn');
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    CustomButton(
                      title: "Phone number",
                      onPressed: () {
                        print('Nút tùy chỉnh đã được nhấn');
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
