import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const LoginScreen(),
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
                    image: AssetImage('assets/logo/logo1.png'),
                  ),
                ),

                const Column(
                  children: [
                    //welcome back
                    CustomTitle(title1: "Welcome", title2: "back"),
                    //login with
                    CustomSecondaryTitle(title: "Login with email")
                  ],
                ),
                const Column(
                  children: [
                    //email input
                    CustomTextField(hint: "Email"),
                    //password input
                    PasswordInput(
                      hint: "Password",
                    ),
                  ],
                ),
                //forgot password
                Padding(
                  padding: const EdgeInsets.only(right: 32),
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
                //login button
                CustomButton(
                  title: "Login",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text('Đây là một ví dụ về dialog đơn giản.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Đóng'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                //or with
                Text("or with social media:",
                    style: Theme.of(context).textTheme.titleLarge),
                //logo media
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                      ),
                      child: const Icon(
                        Icons.facebook_rounded,
                        size: 52,
                      ),
                    ),
                    Container(
                      height: 72,
                      width: 72,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                      ),
                      child: const Icon(
                        Icons.facebook_rounded,
                        size: 52,
                      ),
                    )
                  ],
                ),

                //Don't have a account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have a account? ",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SelectableText(
                      "Sign in",
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
