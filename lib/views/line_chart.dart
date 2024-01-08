// ignore: must_be_immutable
import 'package:currency_exchange_app/core/date_format.dart';
import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/models/history.dart';
import 'package:currency_exchange_app/viewmodel/available_currencies_viewmodel.dart';
import 'package:currency_exchange_app/viewmodel/historical_currency_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CurrencyLineChart extends StatefulWidget {
  @override
  State<CurrencyLineChart> createState() => _CurrencyLineChartState();
}

class _CurrencyLineChartState extends State<CurrencyLineChart> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool? onPressed = false;

  String? selectedCurrencyDropdown1;

  String? selectedCurrencyDropdown2;

  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoricalDataCurrenciesViewModel>(
      builder: (context, historyViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Currency Rate'),
            backgroundColor: Colors.white,
            elevation: 1,
          ),
          body: Consumer<AvailableCurrenciesViewModel>(
            builder: (context, viewModel, child) {
              switch (viewModel.availableCurrenciesFetchState) {
                case FetchState.fetching:
                  return const Center(child: CircularProgressIndicator());
                case FetchState.done:
                  return buildCurrenciesList(viewModel, historyViewModel);
                case FetchState.errored:
                  return const Center(
                    child: Text('Error'),
                  );
                default:
                  return Container(); // You can provide a default widget here
              }
            },
          ),
        );
      },
    );
  }

  String? selectedCurrency;
  Widget lineChart(HistoricalDataCurrenciesViewModel viewModel) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    tooltipBgColor: Colors.amber,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        // DateTime date =
                        //     from!.add(Duration(days: touchedSpot.x.toInt()));
                        return LineTooltipItem(
                          "date",
                          const TextStyle(
                            fontFamily: 'Jost*',
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        );
                      }).toList();
                    })),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                interval: 1, // Set the interval based on your requirements
                getTitlesWidget: (double value, TitleMeta meta) {
                  List<FlSpotWithDate> spots = _getSpots(viewModel);
                  if (value >= 0 && value < spots.length) {
                    // Ensure that the value is within the range of your data
                    final FlSpotWithDate spot = spots[value.toInt()];
                    return Text(spot.date);
                  }
                  return Text('');
                },

                reservedSize: 22,
              )),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
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
            minX: 0,
            maxX:
                viewModel.historicalCurrencyDate!.priceData!.length.toDouble() -
                    1,
            minY: 0,
            maxY: _calculateMaxY(viewModel).roundToDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(viewModel).map((spotWithDate) {
                  return FlSpot(spotWithDate.x, spotWithDate.y);
                }).toList(),
                color: Colors.red,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: .5,
                      color: Colors.red,
                      strokeWidth: 0.2,
                      strokeColor: Colors.red,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrenciesList(AvailableCurrenciesViewModel viewModel,
      HistoricalDataCurrenciesViewModel historicalViewModel) {
    DateTime thirtyDaysFromNow = currentDate.add(Duration(days: 30));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                            color: Colors.black38,
                            width: 1), //border of dropdown button
                        borderRadius: BorderRadius.circular(
                            60), //border raiuds of dropdown button
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: DropdownButton(
                          value: selectedCurrencyDropdown1,
                          items: viewModel
                              .availableCurrencies?.currencies.entries
                              .map<DropdownMenuItem<String>>((currency) {
                            return DropdownMenuItem<String>(
                              value: currency.key,
                              child: Text(currency.key),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCurrencyDropdown1 = value;
                            });
                          },
                          icon: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.arrow_circle_down_sharp)),
                          iconEnabledColor: Colors.white, //Icon color
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),

                          dropdownColor:
                              Colors.white, //dropdown background color
                          underline: Container(), //remove underline
                        ))),
              ),
              SizedBox(width: 16.0),
              Container(
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                            color: Colors.black38,
                            width: 1), //border of dropdown button
                        borderRadius: BorderRadius.circular(
                            60), //border raiuds of dropdown button
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: DropdownButton(
                          value: selectedCurrencyDropdown2,
                          items: viewModel
                              .availableCurrencies?.currencies.entries
                              .map<DropdownMenuItem<String>>((currency) {
                            return DropdownMenuItem<String>(
                              value: currency.key,
                              child: Text(currency.key),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCurrencyDropdown2 = value;
                            });
                          },
                          icon: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.arrow_circle_down_sharp)),
                          iconEnabledColor: Colors.white, //Icon color
                          style: const TextStyle(
                              //te
                              color: Colors.black, //Font color
                              fontSize: 20),
                          dropdownColor: Colors.white,
                          underline: Container(),
                        ))),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date', style: TextStyle(color: Colors.black, fontSize: 15),),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        // textStyle: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 10,
                        //     fontStyle: FontStyle.normal),
                      ),
                      onPressed: () {
                        historicalViewModel =
                            Provider.of<HistoricalDataCurrenciesViewModel>(
                                context,
                                listen: false);
                        historicalViewModel.getHistoricalData(
                            selectedCurrencyDropdown1!,
                            selectedCurrencyDropdown2!,
                            getFormattedDateTime(selectedDate!),
                            getFormattedDateTime(thirtyDaysFromNow));
                        setState(() {
                          onPressed = true;
                        });
                      },
                      child: const Text(
                        'Get Rates',
                        style: TextStyle(
                            color: Colors.black, //Font color
                            fontSize: 15 //font size on dropdown button
                            ),
                      )),
                ),
              ),
            ],
          ),
          onPressed! && historicalViewModel.historicalCurrencyDate != null
              ? lineChart(historicalViewModel)
              : Container()
        ],
      ),
    );
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) {
        return true;
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<FlSpotWithDate> _getSpots(HistoricalDataCurrenciesViewModel viewModel) {
    final List<FlSpotWithDate> spots = [];

    viewModel.historicalCurrencyDate!.priceData!.forEach((date, currencyData) {
      final PriceData? targetCurrencyData =
          currencyData.currencies[selectedCurrencyDropdown2];

      if (targetCurrencyData != null) {
        final double closeValue = targetCurrencyData.close;
        spots.add(FlSpotWithDate(spots.length.toDouble(), closeValue, date));
      }
    } );

    return spots;
  }

  double? maxCloseValue;

  double _calculateMaxY(HistoricalDataCurrenciesViewModel viewModel) {
    maxCloseValue = viewModel.historicalCurrencyDate!.priceData!.entries
        .map((entry) =>
            entry.value.currencies.values.map((currency) => currency.close))
        .expand((values) => values)
        .fold(
            0, (previous, current) => current > previous! ? current : previous);

    return (maxCloseValue! * 1.2).toDouble();
  }

  Text getTitlesX(value) {
    if (value.toInt() == 0) {
      return Text('');
    } else if (value.toInt() == maxCloseValue) {
      return Text('x');
    }
    return Text('X');
  }

  Text getRightTiles(value) {
    return Text('');
  }

  Text getTitlesY(value) {
    if (value.toInt() == 0) {
      return Text('');
    } else if (value.toInt() == maxCloseValue) {
      return Text('');
    }
    return Text('');
  }
}

class FlSpotWithDate {
  final double x;
  final double y;
  final String date;

  FlSpotWithDate(this.x, this.y, this.date);
}
