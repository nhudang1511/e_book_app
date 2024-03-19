import 'dart:async';

import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/repository.dart';
import '../../widget/widget.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formField = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late Timer _timer;
  final SignupCubit _signupCubit = SignupCubit(
    authRepository: AuthRepository(),
    userRepository: UserRepository(),
  );

  @override
  void initState() {
    super.initState();
  }

  bool validatePassword(String value) {
    String pattern =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d!@#$%^&*()\-_+=<>?/{}[\]]{8,}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _signupCubit,
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
                context, MainScreen.routeName, (route) => false);
          }
          if (state.status == SignupStatus.emailExists) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _timer = Timer(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
                return const CustomDialogNotice(
                  title: Icons.info,
                  content: 'Email already exists.',
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
                            image: AssetImage('assets/logo/logo1.png')),
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
                          CustomTextField(
                            hint: "Full Name",
                            controller: fullNameController,
                            onChanged: (value) {
                              _signupCubit.fullNameChanged(value);
                            },
                          ),
                          CustomTextField(
                            hint: "Phone Number",
                            controller: phoneNumberController,
                            onChanged: (value) {
                              _signupCubit.phoneNumberChanged(value);
                            },
                          ),
                          //email input
                          CustomTextField(
                            hint: "Email",
                            controller: emailController,
                            onChanged: (value) {
                              _signupCubit.emailChanged(value);
                            },
                          ),
                          //password input
                          PasswordInput(
                            hint: "Password",
                            controller: passwordController,
                            onChanged: (value) {
                              _signupCubit.passwordChanged(value);
                            },
                          ),
                        ],
                      ),
                      //signup button
                      CustomButton(
                        title: "Sign up",
                        onPressed: () {
                          if (formField.currentState!.validate()) {
                            if (validatePassword(
                                passwordController.value.text)) {
                              _signupCubit.signUpWithEmailAndPassword();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  _timer =
                                      Timer(const Duration(seconds: 3), () {
                                    Navigator.of(context).pop();
                                  });
                                  return const CustomDialogNotice(
                                    title: Icons.info,
                                    content:
                                        'Password must be a minimum 8 characters, at least one uppercase letter, one lowercase letter and one number.',
                                  );
                                },
                              ).then((value) {
                                if (_timer.isActive) {
                                  _timer.cancel();
                                }
                              });
                            }
                          }
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
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Log in",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
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
        ),
      ),
    );
  }
}
