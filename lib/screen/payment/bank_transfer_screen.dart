import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widget/widget.dart';

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});
  static const String routeName = '/bank_transfer';

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  String accountNumber = '7706205089173';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          title: "Bank Transfer",
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2 + 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bank: Agribank',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Account owner: NGUYEN THI QUYNH NHU',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Account number: $accountNumber',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: accountNumber));
                              },
                              icon: const Icon(Icons.copy))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        'assets/image/qr.jpg',
                        height: 200,
                      )
                    ],
                  ),
                ),
                CustomButton(
                  title: 'Done',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
