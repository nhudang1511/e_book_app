import 'dart:async';

import 'package:e_book_app/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/repository.dart';
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
  final ForgotPasswordCubit forgotPasswordCubit = ForgotPasswordCubit(
    authRepository: AuthRepository(),
  );
  final formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => forgotPasswordCubit,
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _timer = Timer(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
                return const CustomDialogNotice(
                  title: Icons.info,
                  content:
                      'The email does not exist or has not been authenticated.',
                );
              },
            ).then((value) {
              if (_timer.isActive) {
                _timer.cancel();
              }
            });
          }
          if (state.status == ForgotPasswordStatus.success) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _timer = Timer(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
                return const CustomDialogNotice(
                  title: Icons.check_circle,
                  content: 'Check mail.',
                );
              },
            ).then((value) {
              if (_timer.isActive) {
                _timer.cancel();
              }
            });
          }
        },
        child: Scaffold(
          appBar: const CustomAppBar(
            title: '',
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                height: currentHeight,
                child: Form(
                  key: formField,
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
                          forgotPasswordCubit.emailChanged(value);
                        },
                      ),
                      BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status,
                        builder: (context, state) {
                          return state.status == ForgotPasswordStatus.submitting
                              ? const CircularProgressIndicator()
                              : CustomButton(
                                  title: "Send OTP",
                                  onPressed: () {
                                    if (formField.currentState!.validate()) {
                                      forgotPasswordCubit.forgotPassword();
                                    }
                                  },
                                );
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
        ),
      ),
    );
  }
}
