import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';

class CustomAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBarHome({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      title: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthenticateState) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if(state is UserLoaded){
                  return Text(
                    'Welcome ${state.user.fullName}',
                    style: Theme.of(context).textTheme.displayMedium,
                  );
                }
                else{
                  return Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.displayMedium,
                  );
                }
              },
            );
          } else {
            return Text(
              title,
              style: Theme.of(context).textTheme.displayMedium,
            );
          }
        },
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      //titleSpacing: -40,
      centerTitle: false,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50.0);
}
