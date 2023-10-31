import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const String routeName = '/change_password';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ChangePasswordScreen(),
    );
  }

  @override
  State<StatefulWidget> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formField = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        title: "Change Password",
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: currentHeight,
            child: Column(
              children: <Widget>[
                CustomTextField(
                  hint: "Old Password",
                  controller: oldPasswordController,
                  onChanged: (value) {
                    print('Text changed to: $value');
                    // Thực hiện xử lý khi giá trị của TextField thay đổi.
                  },
                ),
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
                CustomTextField(
                  hint: "New Password",
                  controller: newPasswordController,
                  onChanged: (value) {
                    print('Text changed to: $value');
                    // Thực hiện xử lý khi giá trị của TextField thay đổi.
                  },
                ),
                CustomTextField(
                  hint: "Confirm New Password",
                  controller: confirmNewPasswordController,
                  onChanged: (value) {
                    print('Text changed to: $value');
                    // Thực hiện xử lý khi giá trị của TextField thay đổi.
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomButton(title: "Update", onPressed: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}
