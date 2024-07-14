import 'package:flutter/material.dart';

class WifiDisconnectScreen extends StatefulWidget {
  final VoidCallback onRetry;
  static const String routeName = '/disconnect';

  const WifiDisconnectScreen({super.key, required this.onRetry});

  @override
  State<WifiDisconnectScreen> createState() => _WifiDisconnectScreenState();
}

class _WifiDisconnectScreenState extends State<WifiDisconnectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset('assets/image/no_wifi.png',
                  height: MediaQuery.of(context).size.height / 2),
            ),
            Text('No Wi-Fi connection available.', style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
