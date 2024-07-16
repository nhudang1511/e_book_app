import 'package:connectivity_plus/connectivity_plus.dart';
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
  bool _isWifiConnected = false;
  bool _isHistoryTop = false;

  @override
  void initState() {
    super.initState();
    _checkWifiConnection();
  }

  Future<void> _checkWifiConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        _isWifiConnected = true;
      });
    } else {
      _navigateToErrorScreen();
    }
    _checkIfDataLoaded();
  }

  void _checkIfDataLoaded() {
    if (_isBookLoaded && _isHistoryTop && _isWifiConnected) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainScreen.routeName,
        (route) => false,
      );
    }
  }

  void _navigateToErrorScreen() {
    Navigator.pushNamed(context, WifiDisconnectScreen.routeName,
        arguments: {'onRetry': _retryConnection});
  }

  void _retryConnection() {
    Navigator.pop(context);
    _checkWifiConnection();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookBloc, BookState>(listener: (context, state) {
          if (state is BookLoaded) {
            setState(() {
              _isBookLoaded = true;
            });
            _checkIfDataLoaded();
          }
        }),
        BlocListener<HistoryBloc, HistoryState>(listener: (context, state) {
          if (state is HistoryTopView) {
            setState(() {
              _isHistoryTop = true;
            });
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
