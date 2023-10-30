import 'package:e_book_app/screen/admin/components/header.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/responsive.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<UsersAccess> userAccess=[
      const UsersAccess(user: 'user', times: 3),
      const UsersAccess(user: 'admin', times: 5),
      const UsersAccess(user: 'guest',times: 10)
    ];
    return SafeArea(
      child: Drawer(
        backgroundColor: const Color(0xFF1B2063),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Header(title: 'Dashboard',),
              DashBoardRow1(userAccess: userAccess),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: GridView.builder(
                  itemCount: demoRecentData.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index){
                      return TotalItems(recentData: demoRecentData[index],);
                    }),
              ),
              const DashBoardRow2()
            ],
          ),
        ),
      ),
    );
  }
}

class DashBoardRow2 extends StatelessWidget {
  const DashBoardRow2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (!Responsive.isMobile(context)) ? Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
              margin: const EdgeInsets.all(10),
              child: SfCartesianChart(
                legend: const Legend(isVisible: true, opacity: 0.7),
                title: ChartTitle(text: 'Inflation rate'),
                plotAreaBorderWidth: 0,
                primaryYAxis: NumericAxis(
                    labelFormat: '{value}%',
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0)),
                primaryXAxis: NumericAxis(
                    interval: 1,
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                series: <ChartSeries<ChartData, int>>[
                  SplineAreaSeries<ChartData, int>(
                    dataSource: <ChartData>[
                      ChartData(2010, 35),
                      ChartData(2011, 13),
                      ChartData(2012, 34),
                      ChartData(2013, 27),
                      ChartData(2014, 40)
                    ],
                    color: const Color.fromRGBO(75, 135, 185, 0.6),
                    borderColor: const Color.fromRGBO(75, 135, 185, 1),
                    borderWidth: 2,
                    name: 'January',
                    xValueMapper: (ChartData sales, _) => sales.x,
                    yValueMapper: (ChartData sales, _) => sales.y,
                  ),
                  SplineAreaSeries<ChartData, int>(
                    dataSource: <ChartData>[
                      ChartData(2010, 15),
                      ChartData(2011, 53),
                      ChartData(2012, 74),
                      ChartData(2013, 17),
                      ChartData(2014, 80)

                    ],
                    borderColor: const Color.fromRGBO(192, 108, 132, 1),
                    color: const Color.fromRGBO(192, 108, 132, 0.6),
                    borderWidth: 2,
                    name: 'February',
                    xValueMapper: (ChartData sales, _) => sales.x,
                    yValueMapper: (ChartData sales, _) => sales.y,
                  )
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            )
        ),
        Expanded(
            flex: 1,
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFFDC844),),
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Top view', style: Theme.of(context).textTheme.displaySmall,),
                  Image.network(
                    'https://product.hstatic.net/200000343865/product/hoang-tu-be_tb-2022_39672e31853b42be866b92319496455d_master.jpg',
                    height: MediaQuery.of(context).size.height/3,
                  ),
                  Text('Hoàng tử bé', style: Theme.of(context).textTheme.displaySmall,)
                ],
              ),
            ))
      ],
    ): Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFFDC844),),
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Top view', style: Theme.of(context).textTheme.displaySmall,),
              Image.network(
                'https://product.hstatic.net/200000343865/product/hoang-tu-be_tb-2022_39672e31853b42be866b92319496455d_master.jpg',
                height: MediaQuery.of(context).size.height/4,
              ),
              Text('Hoàng tử bé', style: Theme.of(context).textTheme.displaySmall,)
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height/3,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
          margin: const EdgeInsets.all(10),
          child: SfCartesianChart(
            legend: const Legend(isVisible: true, opacity: 0.7),
            title: ChartTitle(text: 'Inflation rate'),
            plotAreaBorderWidth: 0,
            primaryYAxis: NumericAxis(
                labelFormat: '{value}%',
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0)),
            primaryXAxis: NumericAxis(
                interval: 1,
                majorGridLines: const MajorGridLines(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift),
            series: <ChartSeries<ChartData, int>>[
              SplineAreaSeries<ChartData, int>(
                dataSource: <ChartData>[
                  ChartData(2010, 35),
                  ChartData(2011, 13),
                  ChartData(2012, 34),
                  ChartData(2013, 27),
                  ChartData(2014, 40)
                ],
                color: const Color.fromRGBO(75, 135, 185, 0.6),
                borderColor: const Color.fromRGBO(75, 135, 185, 1),
                borderWidth: 2,
                name: 'January',
                xValueMapper: (ChartData sales, _) => sales.x,
                yValueMapper: (ChartData sales, _) => sales.y,
              ),
              SplineAreaSeries<ChartData, int>(
                dataSource: <ChartData>[
                  ChartData(2010, 15),
                  ChartData(2011, 53),
                  ChartData(2012, 74),
                  ChartData(2013, 17),
                  ChartData(2014, 80)

                ],
                borderColor: const Color.fromRGBO(192, 108, 132, 1),
                color: const Color.fromRGBO(192, 108, 132, 0.6),
                borderWidth: 2,
                name: 'February',
                xValueMapper: (ChartData sales, _) => sales.x,
                yValueMapper: (ChartData sales, _) => sales.y,
              )
            ],
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ),
      ],
    );
  }
}

class TotalItems extends StatelessWidget {
  const TotalItems({
    super.key, required this.recentData,
  });
  final RecentData recentData;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: const Color(0x59787ECF)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${recentData.number} \n${recentData.title}',
              style: (Responsive.isMobile(context))
                  ? TextStyle(fontSize: 13, color: Colors.white)
                  : (Responsive.isTablet(context))?
              Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white):
              Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white)
              ,
              textAlign: TextAlign.center),
          if(!Responsive.isMobile(context))
            Icon(
            recentData.icon,
            color: Colors.white,
            size: MediaQuery.of(context).size.height/ (Responsive.isTablet(context) ? 15: 8),)
        ],
      ),
    );
  }
}

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
class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}
class RecentData {
  final int number;
  final String title;
  final IconData icon;

  RecentData({required this.icon, required this.title, required this.number});
}

List demoRecentData = [
  RecentData(
    icon: Icons.group_sharp,
    title: 'Total guest',
    number: 100,
  ),
  RecentData(
    icon: Icons.person_add_alt_1_sharp,
    title: 'New users',
    number: 13,
  ),
  RecentData(
    icon: Icons.menu_book_sharp,
    title: 'Read books',
    number: 130,
  ),
];