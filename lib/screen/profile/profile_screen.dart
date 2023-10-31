import 'package:e_book_app/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ProfileScreen());
  }

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (context, state) {
        return state is AuthInitial || state is UnAuthenticateState;
      },
      listener: (context, state) {
        Navigator.pushNamed(context, "/login");
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(title: 'Profile'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //avatar
              Column(
                children: [
                  CircleAvatar(
                    radius: 53,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: Image(
                        image: AssetImage("assets/logo/logo1.png"),
                      ),
                    ),
                  ),
                  //name
                  Text(
                    "My Trần",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  //mail
                  Text(
                    "mytran070202@gmai.com",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 16),
                  )
                ],
              ),
              //edit button
              CustomButton(
                title: "Edit profile",
                onPressed: () {
                  Navigator.pushNamed(context, "/edit_profile");
                },
              ),
              //line
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              //settings
              CustomInkwell(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  mainIcon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: "Settings",
                  currentHeight: currentHeight),
              Padding(
                padding: const EdgeInsets.only(left: 64, right: 64),
                child: Container(
                  height: 0.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              //change password
              CustomInkwell(
                  onTap: () {
                    Navigator.pushNamed(context, '/change_password');
                  },
                  mainIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: "Change Password",
                  currentHeight: currentHeight),
              Padding(
                padding: const EdgeInsets.only(left: 64, right: 64),
                child: Container(
                  height: 0.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              //text notes
              CustomInkwell(
                  onTap: () {
                    Navigator.pushNamed(context, '/text_notes');
                  },
                  mainIcon: Icon(
                    Icons.edit_note,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: "Text notes",
                  currentHeight: currentHeight),
              //line
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              //logout
              CustomInkwell(
                  onTap: () {
                    _authBloc.add(
                      AuthEventLoggedOut(),
                    );
                  },
                  mainIcon: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: "Log out",
                  currentHeight: currentHeight),
            ],
          ),
        ),
      ),
    );
  }
}
