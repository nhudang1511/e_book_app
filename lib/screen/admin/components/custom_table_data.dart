import 'package:flutter/material.dart';

import '../../../model/models.dart';

class CustomTableData extends StatelessWidget {
  const CustomTableData({
    super.key, required this.id, required this.name, required this.quantities, required this.view, required this.adminTable,
  });
  final String id, name, quantities, view;
  final List<AdminTable> adminTable;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DataTable(
          dataTextStyle: const TextStyle(color: Colors.white),
          headingTextStyle: const TextStyle(color: Colors.white),
          border: const TableBorder(horizontalInside: BorderSide(color: Colors.white)),
          columns: [
            DataColumn(label: Text(id)),
            DataColumn(label: Text(name)),
            DataColumn(label: Text(quantities)),
            DataColumn(label: Text(view)),
            const DataColumn(label: Text('Edit')),
            const DataColumn(label: Text('Delete'))
          ],
          rows: List.generate(
              adminTable.length
              , (index) =>
              buildDataRow(adminTable[index])
          )
      ),
    );
  }
  DataRow buildDataRow(AdminTable categoriesAdminTable) {
    return DataRow(
        cells: [
          DataCell(Text(categoriesAdminTable.id)),
          DataCell(Text(categoriesAdminTable.name)),
          DataCell(Text(categoriesAdminTable.quantities)),
          DataCell(Text(categoriesAdminTable.views)),
          DataCell(IconButton(onPressed: (){}, icon: const Icon(Icons.edit, color: Colors.white,))),
          DataCell(IconButton(onPressed: (){}, icon: const Icon(Icons.delete, color: Colors.white,))),
        ]);
  }
}