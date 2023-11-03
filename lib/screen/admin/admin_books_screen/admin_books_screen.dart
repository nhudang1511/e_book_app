import 'package:e_book_app/model/admin_model.dart';
import 'package:flutter/material.dart';
import '../components/custom_table_data.dart';
import '../dashboard/components/header.dart';
class AdminBooksScreen extends StatelessWidget {
  const AdminBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
          backgroundColor: const Color(0xFF1B2063),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Header(title: 'Books',),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 30, top: 20),
                      child: ElevatedButton(
                          onPressed: (){},
                          child: const Text('New')
                      ),
                    ),
                  ],
                ),
                CustomTableData(id: 'Book ID',name: 'Book Name',quantities: 'Quantities',view: 'Views', adminTable: AdminTable.bookAdminTable,)
              ],
            ),
          ),
        )
    );
  }
}
