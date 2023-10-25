import 'package:flutter/material.dart';
import '../../../model/models.dart';
import 'custom_table_data.dart';
import 'header.dart';
class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
          backgroundColor: const Color(0xFF1B2063),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Header(title: 'Users',),
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
                CustomTableData(id: 'User ID',name: 'Users Name',quantities: 'Quantities',view: 'Views', adminTable: AdminTable.userAdminTable,)
              ],
            ),
          ),
        )
    );
  }
}
