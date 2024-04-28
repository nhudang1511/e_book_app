import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cubits.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = "/reset_password";

  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ForgotPasswordCubit _forgotPasswordCubit;

  @override
  void initState() {
    super.initState();
    _forgotPasswordCubit = BlocProvider.of(context);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 24,
              ),
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
                  const CustomTitle(title1: "Reset password", title2: "email"),
                  const CustomSecondaryTitle(
                      title:
                          'Check the reset password email that has been sent to your email.'),
                  CustomButton(
                    title: 'Done',
                    onPressed: () {
                      _forgotPasswordCubit.reset();
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      _forgotPasswordCubit.forgotPassword();
                    },
                    child: Text(
                      'Resent',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
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
