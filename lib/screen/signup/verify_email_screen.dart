import 'package:e_book_app/blocs/blocs.dart';
import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/screen/main/main_screen.dart';
import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  static const String routeName = '/verify_email';

  @override
  State<StatefulWidget> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late SignupCubit _signupCubit;
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _signupCubit = BlocProvider.of(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: WillPopScope(
        onWillPop: () async {
          _authBloc.add(AuthEventLoggedOut());
          return true; // Cho phép đóng màn hình khi nhấn nút back
        },
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: currentHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: currentHeight / 4,
                      child: const Image(
                          image: AssetImage('assets/logo/logo1.png')),
                    ),
                    Column(
                      children: [
                        const CustomTitle(title1: "Verify", title2: "Email"),
                        //with email
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: CustomSecondaryTitle(
                              title:
                                  "Check the verification email that has been sent to your email."),
                        ),
                        CustomButton(
                          title: 'Resent Email',
                          onPressed: () {
                            _signupCubit.sendEmailVerification();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: TextButton(
                            onPressed: () {
                              _authBloc.add(AuthEventLoggedOut());
                              _signupCubit.unVerifyAccount();
                            },
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
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
    );
  }
}
