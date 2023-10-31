import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String routeName = '/edit_profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const EditProfileScreen());
  }

  @override
  State<StatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formField = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(title: "Edit profile",),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: currentHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
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
                const CustomEditTextField(title: "Full Name"),
                const CustomEditTextField(title: "Email"),
                const CustomEditTextField(title: "Phone Number"),

                CustomButton(title: "Update", onPressed: (){}),
                SizedBox(height: currentHeight/3,),
              ],
            ),
          ),
        ),
      ),
    );

  }
}