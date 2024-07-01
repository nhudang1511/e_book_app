import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/contact_model.dart';
import '../../repository/contact/contact_repository.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactRepository;

  ContactBloc(this._contactRepository) : super(ContactInitial()) {
    on<AddNewContactEvent>(_onAddNewContact);
  }

  void _onAddNewContact(event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      await _contactRepository
          .addContact(event.contact)
          .then((value) => emit(AddContact()));
    } catch (e) {
      emit(const ContactError('error'));
    }
  }
}
