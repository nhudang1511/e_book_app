import 'dart:io';

import 'package:e_book_app/blocs/blocs.dart';
import 'package:e_book_app/cubits/cubits.dart';
import 'package:e_book_app/model/models.dart';
import 'package:e_book_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../repository/repository.dart';
import '../../widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit_profile';

  const EditProfileScreen({super.key});

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
  bool isPicked = false;
  File? pickedImage;
  bool isButtonDisabled = true;

  void _onSetDisableButton() {
    if (fullNameController.text.isEmpty &&
        fullNameController.text.isEmpty &&
        isPicked == false) {
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
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.select((AuthBloc bloc) {
      return User.fromFirebaseUser(bloc.state.authUser!);
    });

    final currentHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _editProfileCubit,
      child: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.status == EditProfileStatus.submitting) {
            LoadingOverlay.showLoading(context);
          }
          if (state.status != EditProfileStatus.submitting) {
            LoadingOverlay.dismissLoading();
          }
          if (state.status == EditProfileStatus.success) {
            _editProfileCubit.reset();
            isPicked = false;
            pickedImage = null;
            Navigator.of(context).pop();
            ShowSnackBar.success(InfoMessage.CHANGE_PROFLE_SUCCESS, context);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Form(
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
                                  _onSetDisableButton();
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
                                                user?.photoURL != null
                                                    ? user!.photoURL!
                                                    : 'https://firebasestorage.googleapis.com/v0/b/flutter-e-book-app.appspot.com/o/avatar_user%2Fdefault_avatar.png?alt=media&token=8389d86c-b1bf-4af6-ad6f-a09f41ce7c44',
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
                            CustomTextField(
                              label: "Full Name",
                              content: user?.displayName,
                              controller: fullNameController,
                              onChanged: (value) {
                                _onSetDisableButton();
                                _editProfileCubit.fullNameChanged(value);
                              },
                            ),
                            // CustomTextField(
                            //   label: "Phone Number",
                            //   content: user?.phoneNumber,
                            //   controller: phoneNumberController,
                            //   onChanged: (value) {
                            //     _onSetDisableButton();
                            //
                            //     _editProfileCubit.phoneNumberChanged(value);
                            //   },
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: CustomButton(
                                  title: "Update",
                                  disabled: isButtonDisabled,
                                  onPressed: () {
                                    if (formField.currentState!.validate()) {
                                      _editProfileCubit.updateProfile();
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: currentHeight / 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
