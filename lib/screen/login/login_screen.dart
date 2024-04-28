import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/screen/screen.dart';
import 'package:e_book_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/repository.dart';
import '../../widget/widget.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;
  bool isButtonDisabled = true;

  late LoginCubit _loginCubit;



  void _onSetDisableButton(String text) {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        !isEmail(emailController.text)) {
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
    _loginCubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ShowSnackBar.success(InfoMessage.LOGIN_SUCCESS, context);
        }
        if (state.status == LoginStatus.verifying) {
          Navigator.pushNamed(context, VerifyEmailLoginScreen.routeName);
        }
        if (state.status == LoginStatus.submitting) {
          LoadingOverlay.showLoading(context);
        }
        if (state.status == LoginStatus.error) {
          ShowSnackBar.error(state.exception!, context);
        }
        if (state.status != LoginStatus.submitting) {
          LoadingOverlay.dismissLoading();
        }
        if (state.status == LoginStatus.unVerify) {
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
                              _loginCubit.emailChanged(value);
                              _onSetDisableButton(value);
                            },
                          ),
                          CustomTextField(
                            label: "Password",
                            icon: Icons.lock,
                            controller: passwordController,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return null;
                              }
                              return null;
                            },
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
                              _loginCubit.passwordChanged(value);
                              _onSetDisableButton(value);
                            },
                          ),
                          //password input
                        ],
                      ),
                      //forgot password
                      Row(
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
                      //login button
                      CustomButton(
                        title: "Login",
                        disabled: isButtonDisabled,
                        onPressed: () {
                          if (formField.currentState!.validate()) {
                            _loginCubit.logInWithCredentials();
                          }
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
                              Navigator.pushNamed(
                                  context, SignupScreen.routeName);
                            },
                            child: Text(
                              "Sign in",
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
