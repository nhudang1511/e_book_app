class AdminTable{
  final String id, name, quantities, views;
  AdminTable({required this.id, required this.name, required this.quantities, required this.views});
  static List<AdminTable> categoriesAdminTable = [
    AdminTable(id: '123', name: 'Comedy', quantities: '5', views: '100'),
    AdminTable(id: '124', name: 'Comedy', quantities: '51', views: '100'),
    AdminTable(id: '125', name: 'Comedy', quantities: '25', views: '100'),
    AdminTable(id: '126', name: 'Comedy', quantities: '7', views: '100'),
    AdminTable(id: '127', name: 'Comedy', quantities: '8', views: '100'),
    AdminTable(id: '123', name: 'Comedy', quantities: '5', views: '100'),
    AdminTable(id: '124', name: 'Comedy', quantities: '51', views: '100'),
    AdminTable(id: '125', name: 'Comedy', quantities: '25', views: '100'),
    AdminTable(id: '126', name: 'Comedy', quantities: '7', views: '100'),
    AdminTable(id: '127', name: 'Comedy', quantities: '8', views: '100')
  ];

  static List<AdminTable> bookAdminTable = [
    AdminTable(id: '1234', name: 'Dế mèn phiêu lưu ký', quantities: '5', views: '100'),
    AdminTable(id: '1235', name: 'Hoàng tử bé', quantities: '5', views: '100'),
  ];
  static List<AdminTable> userAdminTable = [
    AdminTable(id: '1234', name: 'Nguyễn Như', quantities: '5', views: '100'),
    AdminTable(id: '1235', name: 'My Trần', quantities: '5', views: '100'),
  ];
}