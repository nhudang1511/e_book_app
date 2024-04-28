import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:e_book_app/repository/coins/coins_repository.dart';
import 'package:e_book_app/screen/payment/bank_transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../../blocs/coins/coins_bloc.dart';
import '../../config/shared_preferences.dart';
import '../../widget/widget.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

class ChoosePaymentScreen extends StatefulWidget {
  const ChoosePaymentScreen({super.key});

  static const String routeName = '/choose_payment';

  @override
  State<ChoosePaymentScreen> createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  int money = 0;
  late CoinsBloc _coinsBloc;
  String uId = '';
  int coins = 0;
  String coinsId = '';

  @override
  void initState() {
    super.initState();
    _coinsBloc = CoinsBloc(CoinsRepository())
      ..add(LoadedCoins(uId: SharedService.getUserId() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _coinsBloc,
      child: BlocListener<CoinsBloc, CoinsState>(
        listener: (context, state) {
          print(state);
          if (state is AddCoins) {
            Navigator.pop(context);
          } else if (state is CoinsLoaded) {
            uId = state.coins.uId ?? '';
            coins = state.coins.quantity ?? 0;
            coinsId = state.coins.coinsId ?? '';
          }
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const CustomAppBar(
              title: "Choose Payment",
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    CustomRadioButton(
                      elevation: 0,
                      absoluteZeroSpacing: true,
                      unSelectedColor: Theme.of(context).colorScheme.background,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      unSelectedBorderColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selectedBorderColor:
                          Theme.of(context).colorScheme.background,
                      buttonLables: const [
                        '1\$ = 300 coins',
                        '5\$ = 2000 coins',
                        '10\$ = 5000 coins',
                      ],
                      buttonValues: const [
                        "1",
                        "5",
                        "10",
                      ],
                      buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 16)),
                      height: 50,
                      horizontal: true,
                      radioButtonValue: (value) {
                        setState(() {
                          money = int.parse(value);
                        });
                      },
                      selectedColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CustomButton(
                        title: "Paypal",
                        onPressed: () async {
                          if (money != 0) {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => PaypalCheckout(
                                sandboxMode: true,
                                clientId:
                                    "AQJChLCRunMImWzjcvmAJ1CnrTMHt5HSzAr8THCu9A3-3e1D0o0wwYUPnSHLxQsNP55FfttQcRmAE5eR",
                                secretKey:
                                    "EKMIwnvm7jEQ3Czs0aXEpuNjYwnkz6r60f3wmOKD5w6ED_-Gv9pfP0Vnol9Vtr3QuAuxGLNggh-5yPlG",
                                returnURL: "success.snippetcoder.com",
                                cancelURL: "cancel.snippetcoder.com",
                                transactions: [
                                  {
                                    "amount": {
                                      "total": money,
                                      "currency": "USD",
                                      "details": {
                                        "subtotal": money,
                                        "shipping": '0',
                                        "shipping_discount": 0
                                      }
                                    },
                                    "description":
                                        "The payment transaction description.",
                                  }
                                ],
                                note:
                                    "Contact us for any questions on your order.",
                                onSuccess: (Map params) async {
                                  print("onSuccess: $params");
                                  if (money == 1) {
                                    coins = coins + 300;
                                  } else if (money == 5) {
                                    coins = coins + 2000;
                                  } else if (money == 10) {
                                    coins = coins + 5000;
                                  }
                                  if (uId != SharedService.getUserId()) {
                                    _coinsBloc.add(AddNewCoinsEvent(
                                        quantity: coins,
                                        uId: SharedService.getUserId() ?? ''));
                                  } else if (uId == SharedService.getUserId()) {
                                    _coinsBloc.add(EditCoinsEvent(
                                        quantity: coins,
                                        uId: SharedService.getUserId() ?? '',
                                        coinsId: coinsId));
                                  }
                                },
                                onError: (error) {
                                  print("onError: $error");
                                  Navigator.pop(context);
                                },
                                onCancel: () {
                                  print('cancelled:');
                                },
                              ),
                            ));
                          } else {
                            Dialogs.materialDialog(
                                msg: 'Please select coins to continue!',
                                title: "Warning",
                                color: Colors.white,
                                context: context,
                                actions: [
                                  IconsButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Ok",
                                    iconData: Icons.cancel,
                                    color: Colors.greenAccent,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    iconColor: Colors.white,
                                  ),
                                ]);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CustomButton(
                        title: "Bank Transfer",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, BankTransferScreen.routeName);
                          if (uId != SharedService.getUserId()) {
                            _coinsBloc.add(AddNewCoinsEvent(
                                quantity: 0,
                                uId: SharedService.getUserId() ?? ''));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
