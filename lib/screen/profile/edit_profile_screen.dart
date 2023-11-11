import 'dart:async';

import 'package:e_book_app/cubits/cubits.dart';

import '../../widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:e_book_app/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit_profile';

  const EditProfileScreen({super.key});

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
  final phoneNumberController = TextEditingController();
  late EditProfileCubit _editProfileCubit;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _editProfileCubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.status == EditProfileStatus.success) {
          Navigator.of(context).pop();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              _timer = Timer(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              return const CustomDialogNotice(
                title: Icons.check_circle,
                content: 'Edited profile successfully.',
              );
            },
          ).then((value) {
            if (_timer.isActive) {
              _timer.cancel();
            }
          });

        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          title: "Edit profile",
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: currentHeight,
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is UserLoaded) {
                    return Form(
                      key: formField,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          CustomEditTextField(
                            title: "Full Name",
                            hint: state.user.fullName,
                            controller: fullNameController,
                            onChanged: (value) {
                              _editProfileCubit.fullNameChanged(value);
                            },
                          ),
                          CustomEditTextField(
                            title: "Phone Number",
                            hint: state.user.phoneNumber,
                            controller: phoneNumberController,
                            onChanged: (value) {
                              _editProfileCubit.phoneNumberChanged(value);
                            },
                          ),
                          CustomButton(
                              title: "Update",
                              onPressed: () {
                                if (formField.currentState!.validate()) {
                                  _editProfileCubit.updateProfire();
                                }
                              }),
                          SizedBox(
                            height: currentHeight / 3,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Text('Something went wrong');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
