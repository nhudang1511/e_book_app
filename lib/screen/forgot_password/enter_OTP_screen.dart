import 'package:flutter/material.dart';
import '../../widget/widget.dart';
import 'package:pinput/pinput.dart';

class EnterOTPScreen extends StatelessWidget {
  static const String routeName = "/enter_otp";
  const EnterOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: currentHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: currentHeight / 4,
                  child: const Image(
                    image: AssetImage("assets/logo/logo1.png"),
                  ),
                ),
                const CustomTitle(title1: "Enter", title2: "OTP"),
                //input OTP
                Pinput(
                  length: 4,
                  autofocus: true,
                  defaultPinTheme: PinTheme(
                    height: currentWidth / 6,
                    width: currentWidth / 6,
                    textStyle: Theme.of(context).textTheme.displayMedium,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                //verify button
                CustomButton(
                  title: "Verify",
                  onPressed: () {
                    print('Nút tùy chỉnh đã được nhấn');
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If you don't receive a code! ",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SelectableText(
                      "Resend",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
