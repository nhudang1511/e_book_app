import 'package:e_book_app/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_book_app/screen/screen.dart';

import '../../config/shared_preferences.dart';
import '../../repository/coins/coins_repository.dart';
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
  late CoinsBloc _coinsBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    // _coinsBloc = CoinsBloc(CoinsRepository())
    //   ..add(LoadedCoins(uId: SharedService.getUserId() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _coinsBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4), // Adjust the radius as needed
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
                              padding:
                                  const EdgeInsets.only(left: 32, right: 32),
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            //settings
                            CustomInkwell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SettingsScreen.routeName);
                                },
                                mainIcon: Icon(
                                  Icons.settings,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: "Settings",
                                currentHeight: currentHeight),
                            //line
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 32, right: 32),
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
            print(state.authUser);
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: const CustomAppBar(title: 'Profile'),
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Column(
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
                                    state.authUser?.photoURL != null
                                        ? state.authUser!.photoURL!
                                        : 'https://firebasestorage.googleapis.com/v0/b/flutter-e-book-app.appspot.com/o/avatar_user%2Fdefault_avatar.png?alt=media&token=8389d86c-b1bf-4af6-ad6f-a09f41ce7c44',
                                    width: 98,
                                    height: 98,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            //name
                            Text(
                              state.authUser?.displayName != null
                                  ? state.authUser!.displayName!
                                  : state.authUser!.email!.split('@')[0],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            //mail
                            Text(
                              state.authUser!.email!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontSize: 16),
                            ),
                            // BlocBuilder<CoinsBloc, CoinsState>(
                            //   builder: (context, state) {
                            //     int coins = 0;
                            //     // print(state);
                            //     if (state is CoinsLoaded) {
                            //       coins = state.coins.quantity ?? 0;
                            //     }
                            //     return Text(
                            //       'Coins: $coins',
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .bodyLarge!
                            //           .copyWith(fontSize: 16),
                            //     );
                            //   },
                            // )
                          ],
                        ),
                        //edit button
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: CustomButton(
                            title: "Edit profile",
                            onPressed: () {
                              Navigator.pushNamed(
                                      context, EditProfileScreen.routeName)
                                  .then((value) => {
                                        _authBloc.add(
                                          AuthEventStarted(),
                                        )
                                      });
                            },
                          ),
                        ),
                        //line
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              //settings
                              CustomInkwell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SettingsScreen.routeName);
                                },
                                mainIcon: Icon(
                                  Icons.settings,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: "Settings",
                                currentHeight: currentHeight,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 32, right: 32),
                                child: Container(
                                  height: 0.5,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              //change password
                              // if (state.user.provider == 'email')
                              CustomInkwell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ChangePasswordScreen.routeName);
                                },
                                mainIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: "Change Password",
                                currentHeight: currentHeight,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 32, right: 32),
                                child: Container(
                                  height: 0.5,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              //text notes
                              CustomInkwell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, TextNotesScreen.routeName,
                                      arguments: state.authUser);
                                },
                                mainIcon: Icon(
                                  Icons.edit_note,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: "Text notes",
                                currentHeight: currentHeight,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 32, right: 32),
                                child: Container(
                                  height: 0.5,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              CustomInkwell(
                                  onTap: () async {
                                    await Navigator.pushNamed(context,
                                            ChoosePaymentScreen.routeName)
                                        .then((value) {
                                      _coinsBloc.add(LoadedCoins(
                                          uId:
                                              SharedService.getUserId() ?? ''));
                                    });
                                  },
                                  mainIcon: Icon(
                                    Icons.monetization_on,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  title: "Add coins",
                                  currentHeight: currentHeight),
                              //line
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
