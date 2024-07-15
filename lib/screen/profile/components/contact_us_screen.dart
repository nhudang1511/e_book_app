import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/repository/contact/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blocs.dart';
import '../../../model/models.dart';
import '../../../utils/show_snack_bar.dart';
import '../../../widget/widget.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  static const String routeName = '/contact';

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  List<String> listProblem = <String>['Question', 'Error', 'Opinion', 'Others'];
  String? chosenValue;
  late ContactBloc contactBloc;
  final textController = TextEditingController();
  bool isButtonDisabled = true;

  void _onSetDisableButton(String text) {
    if (textController.text.isEmpty || chosenValue == null) {
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
    contactBloc = ContactBloc(ContactRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => contactBloc,
      child: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) {
          if(state is AddContact){
            ShowSnackBar.success("Finish add contact", context);
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const CustomAppBar(
              title: "Contact Us",
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Thank you for using our application. '
                        'If there are any problems or comments during use, '
                        'Please fill in the information in the box below; '
                        'we will check and respond as soon as possible.',
                        style: Theme.of(context).textTheme.titleLarge),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Type of problem(required)',
                          style: Theme.of(context).textTheme.headlineMedium,
                        )),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text('Please select one problem',
                            style: Theme.of(context).textTheme.titleLarge),
                        items: listProblem
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ))
                            .toList(),
                        value: chosenValue,
                        onChanged: (String? value) {
                          _onSetDisableButton(value!);
                          setState(() {
                            chosenValue = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            color: Theme.of(context).colorScheme.background,
                          ),
                          elevation: 2,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Problem description (required)',
                          style: Theme.of(context).textTheme.headlineMedium,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: TextField(
                        controller: textController,
                        cursorColor: Theme.of(context).colorScheme.primary,
                        maxLines: MediaQuery.of(context).size.height / 3 ~/ 20,
                        // <--- maxLines
                        decoration: InputDecoration(
                            filled: true,
                            hintText:
                                'Please describe the problem you encountered...',
                            fillColor: Theme.of(context).colorScheme.background,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer)),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.grey)),
                        style: Theme.of(context).textTheme.titleLarge,
                        onChanged: (value) {
                          _onSetDisableButton(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 20,
                          top: MediaQuery.of(context).size.height / 6),
                      child: CustomButton(
                        title: 'Send',
                        onPressed: () {
                          if (!isButtonDisabled) {
                            contactBloc.add(AddNewContactEvent(
                                contact: Contact(
                                    type: chosenValue,
                                    content: textController.text,
                                    createdAt:
                                        Timestamp.fromDate(DateTime.now()),
                                    updateAt:
                                        Timestamp.fromDate(DateTime.now()),
                                    status: true,
                                    uId: SharedService.getUserId())));
                          }
                        },
                        disabled: isButtonDisabled,
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
