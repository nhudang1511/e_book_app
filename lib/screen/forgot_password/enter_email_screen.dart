import 'package:e_book_app/blocs/blocs.dart';
import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/utils.dart';
import '../../widget/widget.dart';

class EnterEmailScreen extends StatefulWidget {
  static const String routeName = "/enter_email";

  const EnterEmailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  late ForgotPasswordCubit _forgotPasswordCubit;
  final formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isButtonDisabled = true;

  void _onSetDisableButton(String text) {
    if (emailController.text.isEmpty ||
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
    _forgotPasswordCubit =BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        print(state);
        if (state.status == ForgotPasswordStatus.error) {
          ShowSnackBar.error(state.exception!, context);
        }
        if (state.status == ForgotPasswordStatus.success) {
          Navigator.pushReplacementNamed(context, ResetPasswordScreen.routeName);
        }
        if (state.status == ForgotPasswordStatus.submitting) {
          LoadingOverlay.showLoading(context);
        }
        if (state.status != ForgotPasswordStatus.submitting) {
          LoadingOverlay.dismissLoading();
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial || state is UnAuthenticateState) {
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
                                image: AssetImage("assets/logo/logo1.png"),
                              ),
                            ),
                            const CustomTitle(
                                title1: "Change with", title2: "email"),
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
                                _forgotPasswordCubit.emailChanged(value);
                                _onSetDisableButton(value);
                              },
                            ),
                            CustomButton(
                              title: "Submit",
                              disabled: isButtonDisabled,
                              onPressed: () {
                                if (formField.currentState!.validate()) {
                                  _forgotPasswordCubit.forgotPassword();
                                }
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
            );
          }
          if (state is AuthenticateState) {
            _forgotPasswordCubit.emailChanged(state.authUser!.email!);
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
                                image: AssetImage("assets/logo/logo1.png"),
                              ),
                            ),
                            const CustomTitle(
                                title1: "Change with", title2: "email"),
                            CustomTextField(
                              label: "Email",
                              content: state.authUser!.email,
                              disabled: true,
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
                                _forgotPasswordCubit.emailChanged(value);
                              },
                            ),
                            CustomButton(
                              title: "Confirm",
                              onPressed: () {
                                if (formField.currentState!.validate()) {
                                  _forgotPasswordCubit.forgotPassword();
                                }
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
            );
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }
}
