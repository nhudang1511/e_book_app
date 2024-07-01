import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
import 'base_contact_repository.dart';

class ContactRepository extends BaseContactRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ContactRepository();

  @override
  Future<void> addContact(Contact contact) {
    return _firebaseFirestore.collection('contact').add(contact.toJson());
  }
}