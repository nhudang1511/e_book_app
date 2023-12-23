import 'dart:async';

import 'package:e_book_app/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/widget.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late LoginCubit _loginCubit;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loginCubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pop(context);
        }
        if (state.status == LoginStatus.emailDiffProvider) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              _timer = Timer(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              return const CustomDialogNotice(
                title: Icons.info,
                content: 'Email already exists and is registered with another provider.',
              );
            },
          ).then((value) {
            if (_timer.isActive) {
              _timer.cancel();
            }
          });
        }
        if (state.status == LoginStatus.error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              _timer = Timer(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              return const CustomDialogNotice(
                title: Icons.info,
                content: 'Invalid account or password.',
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
                    Column(
                      children: [
                        //email input
                        CustomTextField(
                          hint: "Email",
                          controller: emailController,
                          onChanged: (value) {
                            _loginCubit.emailChanged(value);
                          },
                        ),
                        PasswordInput(
                          hint: "Password",
                          controller: passwordController,
                          onChanged: (value) {
                            _loginCubit.passwordChanged(value);
                          },
                        ),
                        //password input
                      ],
                    ),
                    //forgot password
                    Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/enter_email");
                            },
                            child: Text(
                              "Forgot Password?",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //login button
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return state.status == LoginStatus.submitting
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                title: "Login",
                                onPressed: () {
                                  if (formField.currentState!.validate()) {
                                    _loginCubit.logInWithCredentials();
                                  }
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
                        InkWell(
                          onTap: () {
                            _loginCubit.logInWithGoogle();
                          },
                          child: LogoMedia(
                            logo: Image.asset(
                              'assets/icon/icons_google.png',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _loginCubit.logInWithFacebook();
                          },
                          child: LogoMedia(
                            logo: Image.asset(
                              'assets/icon/logos_facebook.png',
                            ),
                          ),
                        ),
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
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/signup");
                          },
                          child: Text(
                            "Sign in",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
    );
  }
}
