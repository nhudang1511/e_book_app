import 'package:flutter/material.dart';
import '../../../model/models.dart';
import '../components/custom_table_data.dart';
import '../dashboard/components/header.dart';
class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
          backgroundColor: const Color(0xFF1B2063),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Header(title: 'Categories',),
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
                CustomTableData(id: 'Cate ID',name: 'Cate Name',quantities: 'Quantities',view: 'Views',adminTable: AdminTable.categoriesAdminTable,)
              ],
            ),
          ),
        )
    );
  }
}

