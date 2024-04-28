import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/screen/screen.dart';
import 'package:e_book_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  bool isButtonDisabled = true;
  bool passwordVisible = true;

  late SignupCubit _signupCubit;

  void _onsetDisableButton(String text) {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        !isEmail(emailController.text) ||
        !isPassword(passwordController.text) ||
        passwordController.text != confirmPasswordController.text) {
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
    _signupCubit = BlocProvider.of(context);
  }
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.routeName, (route) => false);
          ShowSnackBar.success(InfoMessage.CONFIRM_SIGN_UP_SUCCESS, context);
        }
        if (state.status == SignupStatus.submitting) {
          LoadingOverlay.showLoading(context);
        }
        if (state.status == SignupStatus.verifying) {
          LoadingOverlay.dismissLoading();
          Navigator.pushNamed(context, VerifyEmailScreen.routeName);
        }
        if (state.status == SignupStatus.error) {
          LoadingOverlay.dismissLoading();
          ShowSnackBar.error(state.exception!, context);
        }
        if (state.status == SignupStatus.unVerify) {
          Navigator.pushNamedAndRemoveUntil(context,
              MainScreen.routeName, (route) => false);
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
                          //email input
                          CustomTextField(
                            label: "Email",
                            icon: Icons.email,
                            controller: emailController,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return null;
                              }
                              return isEmail(value.toString())
                                  ? null
                                  : InfoMessage.emailValid;
                            },
                            onChanged: (value) {
                              _signupCubit.emailChanged(value);
                              _onsetDisableButton(value);
                            },
                          ),
                          //password input
                          CustomTextField(
                            label: "Password",
                            icon: Icons.lock,
                            controller: passwordController,
                            isObscureText: passwordVisible,
                            suffixIcon: passwordVisible == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onSuffixIcon: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
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
                              _signupCubit.passwordChanged(value);
                              _onsetDisableButton(value);
                            },
                          ),
                          CustomTextField(
                            label: "Confirm Password",
                            icon: Icons.lock,
                            controller: confirmPasswordController,
                            isObscureText: passwordVisible,
                            suffixIcon: passwordVisible == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onSuffixIcon: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return null;
                              }
                              return  passwordController.text == confirmPasswordController.text
                                  ? null
                                  : InfoMessage.confirmPasswordValid;
                            },
                            onChanged: (value) {
                              _onsetDisableButton(value);
                            },
                          ),
                        ],
                      ),
                      //signup button
                      CustomButton(
                        title: "Sign up",
                        disabled: isButtonDisabled,
                        onPressed: () {
                          if (formField.currentState!.validate()) {
                            _signupCubit.signUpWithEmailAndPassword();
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
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
