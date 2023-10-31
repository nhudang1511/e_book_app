import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class EnterNewPasswordScreen extends StatefulWidget {
  static const String routeName = "/enter_new_password";

  const EnterNewPasswordScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EnterNewPasswordScreen(),
    );
  }

  @override
  State<StatefulWidget> createState() => _EnterNewPasswordScreenState();
}

class _EnterNewPasswordScreenState extends State<EnterNewPasswordScreen> {
  final formField = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

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
                Column(
                  children: [
                    PasswordInput(
                      hint: "New password",
                      controller: newPasswordController,
                      onChanged: (value) {
                        print('Text changed to: $value');
                        // Thực hiện xử lý khi giá trị của TextField thay đổi.
                      },
                    ),
                    PasswordInput(
                      hint: "Confirm new password",
                      controller: confirmNewPasswordController,
                      onChanged: (value) {
                        print('Text changed to: $value');
                        // Thực hiện xử lý khi giá trị của TextField thay đổi.
                      },
                    ),
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
