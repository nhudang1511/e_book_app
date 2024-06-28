import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:e_book_app/screen/payment/vnpay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../../blocs/blocs.dart';
import '../../config/shared_preferences.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
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
  late MissionBloc missionBloc;
  late MissionUserBloc missionUserBloc;
  String uId = '';
  int coins = 0;
  String coinsId = '';
  List<Mission> mission = [];
  MissionUser missionUser = MissionUser();
  var listMoneysToCoins  = {
    1: 300,
    5: 2000,
    10: 5000,
  };

  @override
  void initState() {
    super.initState();
    _coinsBloc = CoinsBloc(CoinsRepository())
      ..add(LoadedCoins(uId: SharedService.getUserId() ?? ''));
    missionBloc = MissionBloc(MissionRepository())
      ..add(LoadedMissionsByType(type: 'coins'));
    missionUserBloc = MissionUserBloc(MissionUserRepository());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _coinsBloc),
        BlocProvider(
          create: (context) => missionBloc,
        ),
        BlocProvider(create: (context) => missionUserBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CoinsBloc, CoinsState>(
            listener: (context, state) {
              // print(state);
              if (state is AddCoins) {
                Navigator.pop(context);
              } else if (state is CoinsLoaded) {
                uId = state.coins.uId ?? '';
                coins = state.coins.quantity ?? 0;
                coinsId = state.coins.coinsId ?? '';
              }
            },
          ),
          BlocListener<MissionBloc, MissionState>(
            listener: (context, state) {
              //print('m: $state');
              if (state is MissionLoadedByType) {
                mission = state.mission;
                mission.sort((a, b) => Comparable.compare(b.times as Comparable, a.times as Comparable),);
                for(var m in mission){
                  // print(m.id);
                  missionUserBloc.add(LoadedMissionsUserById(
                      missionId: m.id ?? '',
                      uId: SharedService.getUserId() ?? ''));
                }
              }
            },
          ),
          BlocListener<MissionUserBloc, MissionUserState>(
              listener: (context, state) {
                // print(state);
                if (state is MissionUserLoaded) {
                  missionUser = MissionUser(
                      uId: state.mission.uId,
                      times: state.mission.times! + 1,
                      missionId: state.mission.missionId,
                      status: true,
                      id: state.mission.id
                  );
                } else if (state is MissionUserError) {
                }
              })
        ],
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
                      buttonLables:  listMoneysToCoins.entries.map((entry) {
                        return '${entry.key} \$ = ${entry.value} coins';
                      }).toList(),
                      buttonValues: listMoneysToCoins.keys.toList(),
                      buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 16)),
                      height: 50,
                      horizontal: true,
                      radioButtonValue: (value) {
                        setState(() {
                          money = value;
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
                                  if (money == listMoneysToCoins.keys.elementAt(0)) {
                                    coins = coins + listMoneysToCoins.values.elementAt(0);
                                  } else if (money == listMoneysToCoins.keys.elementAt(1)) {
                                    coins = coins + listMoneysToCoins.values.elementAt(1);
                                  } else if (money == listMoneysToCoins.keys.elementAt(2)) {
                                    coins = coins + listMoneysToCoins.values.elementAt(2);
                                  }
                                 if (uId == SharedService.getUserId()) {
                                    _coinsBloc.add(EditCoinsEvent(
                                        quantity: coins,
                                        uId: SharedService.getUserId() ?? '',
                                        coinsId: coinsId));
                                    missionUserBloc.add(
                                        EditMissionUsers(
                                            mission: missionUser));
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
                        title: "VNPay",
                        onPressed: () {
                          if (money != 0){
                            final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
                              url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
                              version: '2.0.1', //version of VNPAY, default is 2.0.1
                              tmnCode: 'FMJEVP1P', //vnpay tmn code, get from vnpay
                              txnRef: DateTime.now().millisecondsSinceEpoch.toString(), //ref code, default is timestamp
                              orderInfo: 'Pay ${money*23000} VND', //order info, default is Pay Order
                              amount: money * 23000, //amount
                              returnUrl: 'https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
                              ipAdress: '192.168.10.10', //Your IP address
                              vnpayHashKey: '13NZGTEYJKQ36F2BPFB5RWWYCCR0QRP1', //vnpay hash key, get from vnpay
                              vnPayHashType: 'HmacSHA512', //hash type. Default is HmacSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2
                            );
                            VNPAYFlutter.instance.show(
                                paymentUrl: paymentUrl,
                                onPaymentSuccess: (params) {
                                  print('Success');
                                  if (money == listMoneysToCoins.keys.elementAt(0)) {
                                    coins = coins + listMoneysToCoins.values.elementAt(0);
                                  } else if (money == listMoneysToCoins.keys.elementAt(1)) {
                                    coins = coins + listMoneysToCoins.values.elementAt(1);
                                  } else if (money == listMoneysToCoins.keys.elementAt(2)) {
                                    coins = coins + listMoneysToCoins.values.elementAt(2);
                                  }
                                  if (uId == SharedService.getUserId()) {
                                    _coinsBloc.add(EditCoinsEvent(
                                        quantity: coins,
                                        uId: SharedService.getUserId() ?? '',
                                        coinsId: coinsId));
                                    missionUserBloc.add(
                                        EditMissionUsers(
                                            mission: missionUser));
                                  }
                                }, //on mobile transaction success
                                onPaymentError: (params) {
                                  print('error');
                                }, //on mobile transaction error
                                onWebPaymentComplete: (){} //only use in web
                            );
                          }
                          else {
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
                  ],
                ),
              ),
            )),
      ),
    );
  }
}


