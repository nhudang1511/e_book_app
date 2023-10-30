import 'package:e_book_app/config/responsive.dart';
import 'package:e_book_app/menu_app_controller.dart';
import 'package:e_book_app/screen/admin/components/admin_books_screen.dart';
import 'package:e_book_app/screen/admin/components/admin_categories_screen.dart';
import 'package:e_book_app/screen/admin/components/admin_users_screen.dart';
import 'package:e_book_app/screen/admin/components/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  static const String routeName = '/admin_panel';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const AdminPanel());
  }

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0; // Biến để theo dõi tab hiện tại

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 tabs

    // Add listener to switch tabs when DrawerListTile is pressed
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // You can add logic here to perform actions when switching tabs
      }
      setState(() {
        _selectedTabIndex = _tabController.index; // Cập nhật tab hiện tại
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SliderMenu(tabController: _tabController,
          selectedTabIndex: _selectedTabIndex),
      body: SafeArea(
        child: Row(
          children: [
            if(Responsive.isDesktop(context))
             Expanded(
              child: SliderMenu(
                  tabController: _tabController,
                  selectedTabIndex: _selectedTabIndex),
             ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        DashboardScreen(),
                        AdminCategoriesScreen(),
                        AdminBooksScreen(),
                        AdminUsersScreen()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderMenu extends StatelessWidget {
  const SliderMenu({
    super.key,
    required TabController tabController,
    required int selectedTabIndex,
  }) : _tabController = tabController, _selectedTabIndex = selectedTabIndex;

  final TabController _tabController;
  final int _selectedTabIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF601DB2),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(child: Image.asset('assets/logo/logo.png')),
            DrawerListTile(
              title: 'Dashboard',
              icons: Icons.dashboard_rounded,
              press: () {
                _tabController.animateTo(0);
              },
              isSelected: _selectedTabIndex == 0, // Kiểm tra tab hiện tại
            ),
            DrawerListTile(
              title: 'Categories',
              icons: Icons.category_rounded,
              press: () {
                _tabController.animateTo(1);
              },
              isSelected: _selectedTabIndex == 1, // Kiểm tra tab hiện tại
            ),
            DrawerListTile(
              title: 'Books',
              icons: Icons.library_books_rounded,
              press: () {
                _tabController.animateTo(2);
              },
              isSelected: _selectedTabIndex == 2, // Kiểm tra tab hiện tại
            ),
            DrawerListTile(
              title: 'Users',
              icons: Icons.person,
              press: () {
                _tabController.animateTo(3);
              },
              isSelected: _selectedTabIndex == 3, // Kiểm tra tab hiện tại
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icons,
    required this.press,
    required this.isSelected, // Trạng thái chọn
  });

  final String title;
  final IconData icons;
  final VoidCallback press;
  final bool isSelected; // Trạng thái chọn
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icons, color: isSelected ? Colors.white : Colors.white54), // Thay đổi màu dựa trên trạng thái chọn
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white54), // Thay đổi màu dựa trên trạng thái chọn
      ),
    );
  }
}
