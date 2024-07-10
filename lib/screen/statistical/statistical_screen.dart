import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_book_app/blocs/blocs.dart';
import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/repository/bought/bought_repository.dart';
import 'package:e_book_app/repository/deposit/deposit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../widget/widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistical extends StatefulWidget {
  const Statistical({super.key});

  static const String routeName = '/statistical';

  @override
  State<Statistical> createState() => _StatisticalState();
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final num y;
}

class _StatisticalState extends State<Statistical> {
  List<ChartData> chartData = [];
  List<String> listProblem = <String>['All', 'DateTime'];
  String? chosenValue;
  late DepositBloc depositBloc;
  late BoughtBloc boughtBloc;
  bool isDateTime = false;
  DateTime dateTime = DateTime.now();
  num boughtCoins = 0;
  num depositCoins = 0;

  void _onSetDisableButton(String text) {
    if (text == 'DateTime') {
      setState(() {
        depositBloc.add(LoadedDepositByMonth(
            uId: SharedService.getUserId() ?? '', month: dateTime));
        boughtBloc.add(LoadedBoughtByMonth(
            uId: SharedService.getUserId() ?? '', month: dateTime));
        isDateTime = true;
      });
    } else {
      setState(() {
        isDateTime = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    chosenValue = listProblem.first; // Initialize chosenValue here
    depositBloc = DepositBloc(DepositRepository())
      ..add(LoadedDepositByUId(uId: SharedService.getUserId() ?? ''));
    boughtBloc = BoughtBloc(BoughtRepository())
      ..add(LoadedBoughtByUId(uId: SharedService.getUserId() ?? ''));
  }


  @override
  void dispose() {
    super.dispose();
  }

  void _updateChartData() {
    setState(() {
      chartData = [
        ChartData('Bought', boughtCoins),
        ChartData('Deposit', depositCoins),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => boughtBloc),
        BlocProvider(create: (context) => depositBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<BoughtBloc, BoughtState>(listener: (context, state) {
            if (state is BoughtCoinLoaded) {
              boughtCoins = state.boughtCoin;
              _updateChartData(); // Initialize with depositCoins as 0
            }
            else if(state is BoughtError){
              boughtCoins = 0;
              _updateChartData();
            }
          }),
          BlocListener<DepositBloc, DepositState>(listener: (context, state) {
            if (state is DepositCoinLoaded) {
              depositCoins = state.depositCoin;
              _updateChartData();
            }
            else if (state is DepositError){
              depositCoins = 0;
              _updateChartData();
            }
          }),
        ],
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const CustomAppBar(
              title: "User action statistics",
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text('Type: ',
                          style: Theme.of(context).textTheme.displaySmall),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          items: listProblem
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ))
                              .toList(),
                          value: chosenValue,
                          onChanged: (String? value) {
                            _onSetDisableButton(value!);
                            setState(() {
                              chosenValue = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            elevation: 2,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 20),
                  child: Row(children: [
                    Text('Month/Year: ',
                        style: Theme.of(context).textTheme.displaySmall),
                    InkWell(
                      onTap: () {
                        if (isDateTime) {
                          showMonthPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2050),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                dateTime = value;
                                depositBloc.add(LoadedDepositByMonth(
                                    uId: SharedService.getUserId() ?? '',
                                    month: dateTime));
                                boughtBloc.add(LoadedBoughtByMonth(
                                    uId: SharedService.getUserId() ?? '',
                                    month: dateTime));
                              });
                            }
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: isDateTime
                              ? Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                )
                              : null,
                          color: isDateTime
                              ? Colors.transparent
                              : Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(DateFormat('MM/yyyy').format(dateTime),
                                style: Theme.of(context).textTheme.titleLarge),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: SfCircularChart(
                    title: ChartTitle(
                        text: isDateTime
                            ? 'Consumption level during the month ${DateFormat('MM/yyyy').format(dateTime)}'
                            : 'Total level of consumption',
                        alignment: ChartAlignment.center),
                    palette: const [Color(0xFF6739B7), Color(0xFF9A7EC9)],
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        position: LegendPosition.bottom,
                        legendItemBuilder: (String name, dynamic series,
                            dynamic point, int index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: LinearPercentIndicator(
                              percent: point.y / 1000,
                              progressColor: index % 2 == 0
                                  ? const Color(0xFF6739B7)
                                  : const Color(0xFF9A7EC9),
                              leading: Text(point.x.toString()),
                              trailing: Text(point.y.toString()),
                            ),
                          );
                        }),
                    series: <CircularSeries>[
                      // Renders radial bar chart
                      RadialBarSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        innerRadius: '70%',
                        useSeriesColor: true,
                        trackOpacity: 0.1,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
