import 'dart:async';

import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late ChangePasswordCubit _changePasswordCubit;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _changePasswordCubit = BlocProvider.of(context);
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
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {

        if (state.status == ChangePasswordStatus.wrongPassword) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              _timer = Timer(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              return const CustomDialogNotice(
                title: Icons.info,
                content: 'Wrong password.',
              );
            },
          ).then((value) {
            if (_timer.isActive) {
              _timer.cancel();
            }
          });
        }
        if (state.status == ChangePasswordStatus.success) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              _timer = Timer(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              return const CustomDialogNotice(
                title: Icons.check_circle,
                content: 'Changed password successfully.',
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
        appBar: const CustomAppBar(
          title: "Change Password",
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: currentHeight,
              child: Form(
                key: formField,
                child: Column(
                  children: <Widget>[
                    PasswordInput(
                      hint: "Old Password",
                      controller: oldPasswordController,
                      onChanged: (value) {
                        _changePasswordCubit.oldPasswordChanged(value);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 32, top: 16),
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
                    PasswordInput(
                      hint: "New Password",
                      controller: newPasswordController,
                      onChanged: (value) {
                        _changePasswordCubit.newPasswordChanged(value);
                      },
                    ),
                    PasswordInput(
                      hint: "Confirm New Password",
                      controller: confirmNewPasswordController,
                      onChanged: (value) {
                        _changePasswordCubit.confirmNewPasswordChanged(value);
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    CustomButton(
                        title: "Update",
                        onPressed: () {
                          if (formField.currentState!.validate()){
                            if (newPasswordController.value.text ==
                                confirmNewPasswordController.value.text) {
                              if (validatePassword(
                                  newPasswordController.value.text)) {
                                _changePasswordCubit.changePassword();
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
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  _timer =
                                      Timer(const Duration(seconds: 2), () {
                                        Navigator.of(context).pop();
                                      });
                                  return const CustomDialogNotice(
                                    title: Icons.info,
                                    content:
                                    'Password does not match.',
                                  );
                                },
                              ).then((value) {
                                if (_timer.isActive) {
                                  _timer.cancel();
                                }
                              });
                            }
                          }
                        }),
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
