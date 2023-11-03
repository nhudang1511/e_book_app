import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../config/responsive.dart';

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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(0xFFFDC844),),
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(0xFFFDC844),),
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

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}
