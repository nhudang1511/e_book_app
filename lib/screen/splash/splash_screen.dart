import 'package:e_book_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isBookLoaded = false;
  bool _isCategoryLoaded = false;

  void _checkIfDataLoaded() {
    if (_isBookLoaded && _isCategoryLoaded) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainScreen.routeName,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookBloc, BookState>(listener: (context, state) {
          if (state is BookLoaded) {
            _isBookLoaded = true;
            _checkIfDataLoaded();
          }
        }),
        BlocListener<CategoryBloc, CategoryState>(listener: (context, state) {
          if (state is CategoryLoaded) {
            _isCategoryLoaded = true;
            _checkIfDataLoaded();
          }
        }),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(image: AssetImage('assets/logo/logo.png')),
            ),
          ],
        ),
      ),
    );
  }
}
