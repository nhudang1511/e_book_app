import 'package:flutter/material.dart';

import '../../widget/widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(title: 'Profile'),
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
            CustomButton(title: "Edit profile", onPressed: () {}),
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
                mainIcon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: "Log out",
                currentHeight: currentHeight),
          ],
        ),
      ),
    );
  }
}
