part of 'contact_bloc.dart';
abstract class ContactState {
  const ContactState();
}
class ContactInitial extends ContactState {
}
class ContactLoading extends ContactState{
}
class AddContact extends ContactState{
}

class ContactError extends ContactState {
  final String error;

  const ContactError(this.error);
}