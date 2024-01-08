import 'package:currency_exchange_app/core/date_format.dart';
import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/viewmodel/historical_currency_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarChartHistoryData extends StatelessWidget {
  const BarChartHistoryData(
      {required this.startDate,
      required this.baseCurrency,
      required this.endDate,
      required this.targetCurrency,
      super.key});
  final String? baseCurrency;
  final String? targetCurrency;
  final String? startDate;
  final String? endDate;
  // final HistoricalDataCurrenciesViewModel? historicalViewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoricalDataCurrenciesViewModel>(
        builder: (context, viewModel, child) {
      return states(viewModel);
    });
  }

  states(HistoricalDataCurrenciesViewModel viewModel) {
    switch (viewModel.historyCurrenciesFetchState) {
      case FetchState.fetching:
        return Center(child: CircularProgressIndicator());
      case FetchState.done:
        return buildCurrencyChart();
      case FetchState.errored:
        return Center(child: Text('Error: ${viewModel.errorMessage}'));
      default:
        return Container(); // You can provide a default widget here
    }
  }

  buildCurrencyChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.4,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: getTitlesX(value),
                );
              },
            )),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: getTitlesY(value),
                  );
                },
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: getRightTiles(value),
                );
              },
              showTitles: true,
              reservedSize: 40,
            )),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          barGroups: createBarGroups(),
        ),
      ),
    );
  }

  Text getTitlesX(value) {
    if (value.toInt() == 0) {
      return Text('X');
    } else if (value.toInt() == 0) {
      return Text('to');
    }
    return Text('');
  }

  Text getRightTiles(value) {
    return Text('');
  }

  Text getTitlesY(value) {
    if (value.toInt() == 0) {
      return Text('0');
    } else if (value.toInt() == 0) {
      return Text('');
    }
    return Text('');
  }

  List<BarChartGroupData> createBarGroups() {
    List<BarChartGroupData> barGroups = [];

    int index = 0;

    // priceData.forEach((date, currencies) {
    //   List<BarChartRodData> barRods = [];

    //   currencies.forEach((currency, data) {
    //     barRods.add(
    //       BarChartRodData(
    //         y: data['close']!,
    //         color: getColor(index),
    //         width: 22,
    //         borderRadius: BorderRadius.circular(6), toY: 1.2,
    //       ),
    //     );
    //   });

    //   barGroups.add(
    //     BarChartGroupData(
    //       x: index++,
    //       barRods: barRods,
    //       showingTooltipIndicators: [0],
    //     ),
    //   );
    // });

    return barGroups;
  }

  Color getColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple
    ];
    return colors[index % colors.length];
  }
}
