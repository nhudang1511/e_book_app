import 'package:e_book_app/config/responsive.dart';
import 'package:flutter/material.dart';

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
            if(!Responsive.isDesktop(context))
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.white),))
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
      onTap: (){
        press();
        Navigator.of(context).pop();
      },
      horizontalTitleGap: 0.0,
      leading: Icon(icons, color: isSelected ? Colors.white : Colors.white54), // Thay đổi màu dựa trên trạng thái chọn
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white54), // Thay đổi màu dựa trên trạng thái chọn
      ),
    );
  }
}