import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/screen/forgot_password/enter_email_screen.dart';
import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/repository.dart';
import '../../utils/utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const String routeName = '/change_password';

  @override
  State<StatefulWidget> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formField = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  bool passwordVisible = true;
  bool isButtonDisabled = true;
  bool newPasswordVisible = true;

  final ChangePasswordCubit _changePasswordCubit = ChangePasswordCubit(
    authRepository: AuthRepository(),
  );

  void _onSetDisableButton(String text) {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty ||
        !isPassword(newPasswordController.text) ||
        newPasswordController.text != confirmNewPasswordController.text) {
      setState(() {
        isButtonDisabled = true;
      });
    } else {
      setState(() {
        isButtonDisabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //_changePasswordCubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _changePasswordCubit,
      child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.submitting) {
            LoadingOverlay.showLoading(context);
          }
          if (state.status != ChangePasswordStatus.submitting) {
            LoadingOverlay.dismissLoading();
          }
          if (state.status == ChangePasswordStatus.error) {
            ShowSnackBar.error(state.exception!, context);
          }
          if (state.status == ChangePasswordStatus.success) {
            Navigator.pop(context);
            ShowSnackBar.success(InfoMessage.CHANGE_PASSWORD_SUCCESS, context);
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                          label: "Old Password",
                          icon: Icons.lock,
                          controller: oldPasswordController,
                          isObscureText: passwordVisible,
                          suffixIcon: passwordVisible == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSuffixIcon: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          onChanged: (value) {
                            _changePasswordCubit.oldPasswordChanged(value);
                            _onSetDisableButton(value);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, EnterEmailScreen.routeName);
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomTextField(
                          label: "New Password",
                          icon: Icons.lock,
                          controller: newPasswordController,
                          isObscureText: newPasswordVisible,
                          suffixIcon: newPasswordVisible == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSuffixIcon: () {
                            setState(() {
                              newPasswordVisible = !newPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return null;
                            }
                            return isPassword(value.toString())
                                ? null
                                : InfoMessage.passwordValid;
                          },
                          onChanged: (value) {
                            _changePasswordCubit.newPasswordChanged(value);
                            _onSetDisableButton(value);
                          },
                        ),
                        CustomTextField(
                          label: "Confirm New Password",
                          icon: Icons.lock,
                          controller: confirmNewPasswordController,
                          isObscureText: newPasswordVisible,
                          suffixIcon: newPasswordVisible == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSuffixIcon: () {
                            setState(() {
                              newPasswordVisible = !newPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return null;
                            }
                            return newPasswordController.text ==
                                    confirmNewPasswordController.text
                                ? null
                                : InfoMessage.confirmPasswordValid;
                          },
                          onChanged: (value) {
                            _onSetDisableButton(value);
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        CustomButton(
                          title: "Update",
                          disabled: isButtonDisabled,
                          onPressed: () {
                            if (formField.currentState!.validate()) {
                              _changePasswordCubit.changePassword();
                            }
                          },
                        ),
                      ],
                    ),
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
