import 'package:e_book_app/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_book_app/screen/screen.dart';

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
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is UnAuthenticateState) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const CustomAppBar(title: 'Profile'),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //avatar
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 53,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: Image(
                              image: AssetImage("assets/logo/logo1.png"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Welcome to Ebook App",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    //edit button
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  100), // Adjust the radius as needed
                            ),
                          ),
                        ),
                        child: Text(
                          "Log in",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                        ),
                      ),
                    ),
                    //line
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: <Widget>[
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is AuthenticateState) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const CustomAppBar(title: 'Profile'),
            body: SingleChildScrollView(
              child: Center(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is UserLoaded) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //avatar
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 53,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 50,
                                  child: ClipOval(
                                    child: Image.network(
                                      state.user.imageUrl,
                                      width: 98,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              //name
                              Text(
                                state.user.fullName, textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              //mail
                              Text(
                                state.user.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 16),
                              )
                            ],
                          ),
                          //edit button
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: CustomButton(
                              title: "Edit profile",
                              onPressed: () {
                                Navigator.pushNamed(context, "/edit_profile");
                              },
                            ),
                          ),
                          //line
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 32, right: 32),
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: "Settings",
                                    currentHeight: currentHeight),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 64, right: 64),
                                  child: Container(
                                    height: 0.5,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                                //change password
                                if (state.user.provider == 'email')
                                  Column(
                                    children: [
                                      CustomInkwell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/change_password');
                                          },
                                          mainIcon: Icon(
                                            Icons.lock,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          title: "Change Password",
                                          currentHeight: currentHeight),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 64, right: 64),
                                        child: Container(
                                          height: 0.5,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                //text notes
                                CustomInkwell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/text_notes', arguments: state.user);
                                    },
                                    mainIcon: Icon(
                                      Icons.edit_note,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: "Text notes",
                                    currentHeight: currentHeight),
                                //line
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 32, right: 32),
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('Something went wrong');
                    }
                  },
                ),
              ),
            ),
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
