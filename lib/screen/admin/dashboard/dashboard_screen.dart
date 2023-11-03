import 'package:e_book_app/screen/admin/dashboard/components/header.dart';
import 'package:flutter/material.dart';
import '../../../config/responsive.dart';
import 'components/dashboard_row1.dart';
import 'components/dashboard_row2.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<UsersAccess> userAccess=[
      const UsersAccess(user: 'user', times: 3),
      const UsersAccess(user: 'admin', times: 5),
      const UsersAccess(user: 'guest',times: 10)
    ];
    return SafeArea(
      child: Drawer(
        backgroundColor: const Color(0xFF1B2063),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Header(title: 'Dashboard',),
              DashBoardRow1(userAccess: userAccess),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: GridView.builder(
                  itemCount: demoRecentData.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index){
                      return TotalItems(recentData: demoRecentData[index],);
                    }),
              ),
              const DashBoardRow2()
            ],
          ),
        ),
      ),
    );
  }
}

class TotalItems extends StatelessWidget {
  const TotalItems({
    super.key, required this.recentData,
  });
  final RecentData recentData;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: const Color(0x59787ECF)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${recentData.number} \n${recentData.title}',
              style: (Responsive.isMobile(context))
                  ? const TextStyle(fontSize: 13, color: Colors.white)
                  : (Responsive.isTablet(context))?
              Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white):
              Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white)
              ,
              textAlign: TextAlign.center),
          if(!Responsive.isMobile(context))
            Icon(
              recentData.icon,
              color: Colors.white,
              size: MediaQuery.of(context).size.height/ (Responsive.isTablet(context) ? 15: 8),)
        ],
      ),
    );
  }
}
class RecentData {
  final int number;
  final String title;
  final IconData icon;

  RecentData({required this.icon, required this.title, required this.number});
}

List demoRecentData = [
  RecentData(
    icon: Icons.group_sharp,
    title: 'Total guest',
    number: 100,
  ),
  RecentData(
    icon: Icons.person_add_alt_1_sharp,
    title: 'New users',
    number: 13,
  ),
  RecentData(
    icon: Icons.menu_book_sharp,
    title: 'Read books',
    number: 130,
  ),
];
