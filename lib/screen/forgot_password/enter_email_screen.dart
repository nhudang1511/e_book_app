import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class EnterEmailScreen extends StatefulWidget {
  static const String routeName = "/enter_email";

  const EnterEmailScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EnterEmailScreen(),
    );
  }

  @override
  State<StatefulWidget> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final formField = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
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
                    child: const Image(
                      image: AssetImage("assets/logo/logo1.png"),
                    ),
                  ),
                  const CustomTitle(title1: "Change with", title2: "email"),
                  CustomTextField(
                    hint: "Email",
                    controller: emailController,
                    onChanged: (value) {
                      print('Text changed to: $value');
                      // Thực hiện xử lý khi giá trị của TextField thay đổi.
                    },
                  ),
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
      ),
    );
  }
}
