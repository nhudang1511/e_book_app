part of 'contact_bloc.dart';

abstract class ContactEvent{
  const ContactEvent();
}
class AddNewContactEvent extends ContactEvent {
  final Contact contact;

  const AddNewContactEvent({
    required this.contact
  });
}