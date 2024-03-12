import 'dart:async';
import 'dart:io';

import 'package:e_book_app/cubits/cubits.dart';
import 'package:image_picker/image_picker.dart';

import '../../repository/repository.dart';
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
  final EditProfileCubit _editProfileCubit = EditProfileCubit(
    authRepository: AuthRepository(),
    userRepository: UserRepository(),
  );
  late Timer _timer;
  bool isPicked = false;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _editProfileCubit,
      child: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.status == EditProfileStatus.submitting) {}
          if (state.status == EditProfileStatus.success) {
            _editProfileCubit.reset();
            isPicked = false;
            pickedImage = null;
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
                            InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  pickedImage = File(image.path);
                                  setState(() {
                                    isPicked = true;
                                  });
                                  _editProfileCubit
                                      .fileAvatarChanged(pickedImage!);
                                }
                              },
                              child: CircleAvatar(
                                radius: 53,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 50,
                                      child: ClipOval(
                                        child: isPicked
                                            ? Image.file(
                                                pickedImage!,
                                                width: 98,
                                                height: 98,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                state.user.imageUrl,
                                                width: 98,
                                                height: 98,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                    _editProfileCubit.updateProfile();
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
      ),
    );
  }
}
