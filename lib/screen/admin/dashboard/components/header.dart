import 'package:flutter/material.dart';
import 'package:e_book_app/config/responsive.dart';
import 'package:e_book_app/screen/admin/components/menu_app_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget {
  const Header({
    super.key, required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF601DB2),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(!Responsive.isDesktop(context))
            IconButton(
                onPressed: context.read<MenuAppController>().controlMenu,
                icon: const Icon(Icons.menu, color: Colors.white,)),
          Text(title, style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),),
          const ProfileCard()
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: const Icon(Icons.person)),
        const SizedBox(width: 10,),
        if(!Responsive.isMobile(context))
          const Text('Nguyễn Như', style: TextStyle(color: Colors.white),),
        PopupMenuButton(
            offset: const Offset(0, 60), // SET THE (X,Y) POSITION
            iconSize: 30,
            color: const Color(0xFF601DB2),
            icon: const Icon(
              Icons.keyboard_arrow_down, // CHOOSE YOUR CUSTOM ICON
              color: Colors.white,
            ),
            itemBuilder: (context){
              return [
                PopupMenuItem(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/profile.png',
                          width: MediaQuery.of(context).size.width/4,
                          height: MediaQuery.of(context).size.height/4,
                        ),
                        const Text('Nguyễn Như', style: TextStyle(color: Colors.white)),
                        const Text('nhudang1511@gmail.com', style: TextStyle(color: Colors.white),),
                        const Divider(color: Colors.white,height: 5,)
                      ],)
                ),
                const PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.settings, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Settings', style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.help, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Helps', style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                    value: 'Option 3',
                    child: Column(
                      children: [
                        Divider(color: Colors.white,height: 5,),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.logout_outlined, color: Colors.white,),
                            SizedBox(width: 10,),
                            Text('Settings', style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ],
                    )
                ),
              ];
            })
      ],
    );
  }
}
