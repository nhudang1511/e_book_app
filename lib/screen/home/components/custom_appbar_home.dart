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
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      title: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthenticateState) {
            return Text(
              'Welcome '
              '${state.authUser?.displayName != null && state.authUser!.displayName!.isNotEmpty ? state.authUser?.displayName! : state.authUser?.email!.split('@')[0]}',
              style: Theme.of(context).textTheme.displayMedium,
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
  Size get preferredSize => const Size.fromHeight(50.0);
}
