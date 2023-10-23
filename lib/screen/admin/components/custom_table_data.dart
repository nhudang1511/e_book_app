import 'package:flutter/material.dart';

import '../../../model/models.dart';

class CustomTableData extends StatelessWidget {
  const CustomTableData({
    Key? key,
    required this.id,
    required this.name,
    required this.quantities,
    required this.view,
    required this.adminTable,
  }) : super(key: key);

  final String id, name, quantities, view;
  final List<AdminTable> adminTable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Theme(
        data: Theme.of(context).copyWith(
            cardColor: const Color(0xFF1B2063),
            cardTheme: CardTheme(shape: Border.all(color: Colors.white, width: 2)),
            dividerColor: Colors.white,
          dataTableTheme: const DataTableThemeData(
            dataTextStyle: TextStyle(color: Colors.white),
            headingTextStyle: TextStyle(color: Colors.white),

          ),
          iconTheme: const IconThemeData(color: Colors.white,),
          textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.white)),
        ),
        child: PaginatedDataTable(
          columns: [
            DataColumn(label: Text(id)),
            DataColumn(label: Text(name)),
            DataColumn(label: Text(quantities)),
            DataColumn(label: Text(view)),
            const DataColumn(label: Text('Edit')),
            const DataColumn(label: Text('Delete')),
          ],
          source: _DataSource(adminTable),
          rowsPerPage: 5, // Change this to set the number of rows per page.
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<AdminTable> adminTable;

  _DataSource(this.adminTable);

  @override
  DataRow getRow(int index) {
    final item = adminTable[index];
    return DataRow(cells: [
      DataCell(Text(item.id)),
      DataCell(Text(item.name)),
      DataCell(Text(item.quantities)),
      DataCell(Text(item.views)),
      DataCell(IconButton(
        onPressed: () {},
        icon: const Icon(Icons.edit, color: Colors.white),
      )),
      DataCell(IconButton(
        onPressed: () {},
        icon: const Icon(Icons.delete, color: Colors.white),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => adminTable.length;

  @override
  int get selectedRowCount => 0;
}
