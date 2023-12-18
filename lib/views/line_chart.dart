import 'package:currency_exchange_app/core/date_format.dart';
import 'package:currency_exchange_app/models/history.dart';
import 'package:currency_exchange_app/viewmodel/historical_currency_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyBarChart extends StatelessWidget {
  // fields
  final HistoricalData? historicalData;

  /// The date to display currency history data from
  final DateTime? from;

  /// The date to display currency history data to
  final DateTime? to;

  /// The duration difference between [from] and [to]
  Duration? _period;

    Map<String, double>? priceData;

  /// the maximum X value for the graph
  double? _maxX;

  /// the maximum y value for the graph
  double? _maxY;

  // methods
  CurrencyBarChart({
    Key? key,
    required this.historicalData,
    required this.from,
    required this.to,
  }) : super(key: key) ;
  // {
  //   _period = to!.difference(from!);
  //   priceData = Map();
  //   for (int i = 0; i < _period!.inDays; i++) {
  //     int data = historicalData!.priceData!.entries.where((data) {
  //       return getFormattedDateTime(DateTime.parse(data.key)) ==
  //           getFormattedDateTime(from!.add(Duration(days: i)));
  //     }).length;
  //     // priceData.addAll({i: data});
  //   }
  //   _maxX = (priceData!.length - 1).toDouble();
  //   _maxY = priceData!.values.reduce((a, b) => a > b ? a : b) * 1.5;
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoricalDataCurrenciesViewModel>(
        builder: (context, viewModel, child) {
        return AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: BarChart(
                  BarChartData(
                    // groupsSpace: 10,
                      alignment: BarChartAlignment.spaceBetween,
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: getTitlesBottom(value),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 8,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                        topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            interval: 8,
                            showTitles: true,
                            getTitlesWidget: rightTitles,
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(touchTooltipData:
                      BarTouchTooltipData(getTooltipItem:
                          (group, groupIndex, touchedSpots, rodIndex) {
                        DateTime date =
                        from!.add(Duration(days: touchedSpots.fromY.toInt()));
                        return BarTooltipItem(
                          "${getFormattedDateTime(DateTime.parse(viewModel.historicalCurrencyDate!.startDate!))}",
                          TextStyle(color: Colors.black, fontSize: 12),
                        );
                        // }).toList();
                      })),
                      maxY: 2.roundToDouble(),
                      barGroups: _chartGroups(context,viewModel)),
                )));
      }
    );
  }

  List<BarChartGroupData> _chartGroups(context, HistoricalDataCurrenciesViewModel viewModel) {
    return viewModel.historicalCurrencyDate!.priceData!.keys
        .map((point) => BarChartGroupData(x: int.parse(point), barRods: [
      BarChartRodData(
        toY: priceData![point]!.toDouble(),
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.zero,
      )
    ]))
        .toList();
  }

  Text getTitlesBottom(value) {
    if (value.toInt() == 0) {
      return Text(
       'date',
        style: TextStyle(color: Colors.black54, fontSize: 12),
      );
    } else if (value.toInt() == _maxX) {
      return Text('date');
    }
    return Text('');
  }
  Widget rightTitles(double value, TitleMeta meta) {
    return Text('');
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(color: Colors.black54, fontSize: 12);
    if (value.toInt() == 0) {
      return Text("0");
    } else if (value.toInt() == _maxY!.toInt()) {
      return Text(value.toStringAsFixed(0),style: style,);
    }
    return Text('');
  }
}
