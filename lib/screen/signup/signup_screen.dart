import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SignupScreen(),
    );
  }

  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: currentHeight,
            child: Form(
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
                  Column(
                    children: [
                      //email input
                      CustomTextField(
                        hint: "Email",
                        controller: emailController,
                        onChanged: (value) {
                          print('Text changed to: $value');
                          // Thực hiện xử lý khi giá trị của TextField thay đổi.
                        },
                      ),
                      //password input
                      PasswordInput(
                        hint: "Password",
                        controller: passwordController,
                        onChanged: (value) {
                          print('Text changed to: $value');
                          // Thực hiện xử lý khi giá trị của TextField thay đổi.
                        },
                      ),
                      //confirm pass input
                      PasswordInput(
                        hint: "Confirm password",
                        controller: confirmPasswordController,
                        onChanged: (value) {
                          print('Text changed to: $value');
                          // Thực hiện xử lý khi giá trị của TextField thay đổi.
                        },
                      ),
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
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          "Log in",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
