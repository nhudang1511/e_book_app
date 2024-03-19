import 'package:e_book_app/blocs/blocs.dart';
import 'package:e_book_app/config/theme/theme.dart';
import 'package:e_book_app/screen/screen.dart';
import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
    late AuthBloc _authBloc;

    @override
    void initState() {
      super.initState();
      _authBloc = BlocProvider.of<AuthBloc>(context);
    }
    @override
    void dispose() {
      super.dispose();
      _authBloc.close();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        title: "Settings",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32, top: 32),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.nightlight,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Dark mode",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Switch(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: Provider.of<ThemeProvider>(context).themeData == darkTheme,
                          onChanged: (bool value) {
                            Provider.of<ThemeProvider>(context, listen:  false).toggleTheme();
                          },
                        )),
                  ],
                ),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state){
              if (state is AuthInitial || state is UnAuthenticateState){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CustomButton(
                    title: "Log in",
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                  ),
                );
              }
              if (state is AuthenticateState) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CustomButton(
                    title: "Log out",
                    onPressed: () {
                      _authBloc.add(AuthEventLoggedOut());
                      Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName, (route) => false);
                    },
                  ),
                );
              }
              else {
                return const Text("Something went wrong");
              }
            })
          ],
        ),
      ),
    );
  }
}
