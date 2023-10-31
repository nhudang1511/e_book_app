import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../config/responsive.dart';

class DashBoardRow1 extends StatelessWidget {
  const DashBoardRow1({
    super.key,
    required this.userAccess,
  });

  final List<UsersAccess> userAccess;

  @override
  Widget build(BuildContext context) {

    return (!Responsive.isMobile(context)) ?
    Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
            margin: const EdgeInsets.all(10),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
              title: ChartTitle(text: 'Monthly Access'),
              series:  <ChartSeries<UsersAccess, String>>[
                BarSeries<UsersAccess, String>(
                  dataSource: const <UsersAccess>[
                    UsersAccess(user: 'Jan',times: 5),
                    UsersAccess(user: 'Feb',times: 8),
                    UsersAccess(user: 'Mar',times: 14),
                    UsersAccess(user: 'Apr',times: 32),
                    UsersAccess(user: 'May',times: 28),

                  ],
                  xValueMapper: (UsersAccess sales, _) => sales.user,
                  yValueMapper: (UsersAccess sales, _) => sales.times,
                  color: const Color.fromRGBO(8, 142, 255, 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10,),
        Expanded(
            flex: 1,
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
              margin: const EdgeInsets.all(10),
              child: SfCircularChart(
                title: ChartTitle(text: 'Access'),
                legend: const Legend(isVisible: true),
                series:[
                  PieSeries<UsersAccess,String>(
                      dataSource: userAccess,
                      xValueMapper: (UsersAccess data,_)=> data.user,
                      yValueMapper: (UsersAccess data,_)=>data.times,
                      dataLabelSettings: const DataLabelSettings(isVisible: true,)
                  )
                ],
              ),
            )
        )
      ],
    ):
    Column(children: [
      Container(
        height: MediaQuery.of(context).size.height/3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
        margin: const EdgeInsets.all(10),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
          title: ChartTitle(text: 'Monthly Access'),
          series:  <ChartSeries<UsersAccess, String>>[
            BarSeries<UsersAccess, String>(
              dataSource: const <UsersAccess>[
                UsersAccess(user: 'Jan',times: 5),
                UsersAccess(user: 'Feb',times: 8),
                UsersAccess(user: 'Mar',times: 14),
                UsersAccess(user: 'Apr',times: 32),
                UsersAccess(user: 'May',times: 28),

              ],
              xValueMapper: (UsersAccess sales, _) => sales.user,
              yValueMapper: (UsersAccess sales, _) => sales.times,
              color: const Color.fromRGBO(8, 142, 255, 1),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10,),
      Container(
        height: MediaQuery.of(context).size.height/3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
        margin: const EdgeInsets.all(10),
        child: SfCircularChart(
          title: ChartTitle(text: 'Access'),
          legend: const Legend(isVisible: true),
          series:[
            PieSeries<UsersAccess,String>(
                dataSource: userAccess,
                xValueMapper: (UsersAccess data,_)=> data.user,
                yValueMapper: (UsersAccess data,_)=>data.times,
                dataLabelSettings: const DataLabelSettings(isVisible: true,)
            )
          ],
        ),
      )
    ],);
  }
}
class UsersAccess {
  const UsersAccess({required this.user, required this.times});
  final String user;
  final int times;
}