import 'package:e_book_app/model/models.dart';
abstract class BaseContactRepository{
  Future<void> addContact(Contact contact);
}