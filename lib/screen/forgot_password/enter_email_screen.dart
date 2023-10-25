import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class EnterEmailScreen extends StatelessWidget {
  static const String routeName = "enter_email";

  const EnterEmailScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EnterEmailScreen(),
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
                const CustomTitle(title1: "Change with", title2: "email"),
                const CustomTextField(hint: "Email"),
                CustomButton(
                  title: "Send OTP",
                  onPressed: () {
                    print('Nút tùy chỉnh đã được nhấn');
                  },
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
