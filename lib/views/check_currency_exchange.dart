import 'package:currency_exchange_app/core/date_format.dart';
import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/models/history.dart';
import 'package:currency_exchange_app/viewmodel/available_currencies_viewmodel.dart';
import 'package:currency_exchange_app/viewmodel/currency_rate_viewmodel.dart';
import 'package:currency_exchange_app/viewmodel/historical_currency_data.dart';
import 'package:currency_exchange_app/views/bar_chart.dart';
import 'package:currency_exchange_app/views/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoricalExchangeRate extends StatefulWidget {
  const HistoricalExchangeRate({super.key});

  @override
  State<HistoricalExchangeRate> createState() => _HistoricalExchangeRateState();
}

class _HistoricalExchangeRateState extends State<HistoricalExchangeRate> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? onPressed = false;
  String? selectedCurrencyDropdown1;
  String? selectedCurrencyDropdown2;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoricalDataCurrenciesViewModel>(
        builder: (context, historyViewModel, child) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Currency Rate'),
          backgroundColor: Colors.white,
        ),
        body: Consumer<AvailableCurrenciesViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.availableCurrenciesFetchState) {
              case FetchState.fetching:
                return const Center(child: CircularProgressIndicator());
              case FetchState.done:
                return buildCurrenciesList(viewModel, historyViewModel);
              case FetchState.errored:
                return showErrorAlert(
                    context,
                    historyViewModel.historicalCurrencyDate!.priceData!.isEmpty,
                    historyViewModel!.errorMessage);
              default:
                return Container(); // You can provide a default widget here
            }
          },
        ),
      );
    });
  }

  double _calculateMaxY(HistoricalDataCurrenciesViewModel viewModel) {
    double maxCloseValue = viewModel.historicalCurrencyDate!.priceData!.entries
        .map((entry) =>
            entry.value.currencies.values.map((currency) => currency.close))
        .expand((values) => values)
        .fold(
            0, (previous, current) => current > previous ? current : previous);
    return (maxCloseValue * 1.2).toDouble();
  }

  String? selectedCurrency;
  Widget buildCurrenciesList(AvailableCurrenciesViewModel viewModel,
      HistoricalDataCurrenciesViewModel historicalViewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
         width: MediaQuery.of(context).size.width * 1.2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors
                            .grey[300], //background color of dropdown button
                        border: Border.all(color: Colors.black38, width: 1),
                        borderRadius: BorderRadius.circular(50),
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
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            dropdownColor: Colors.white,
                            underline: Container(),
                          ))),
                ),
                const SizedBox(width: 16.0),
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
                              //get value when changed
                              setState(() {
                                selectedCurrencyDropdown2 = value;
                              });
                            },
                            icon: const Padding(
                                //Icon at tail, arrow bottom is default icon
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.arrow_circle_down_sharp)),
                            iconEnabledColor: Colors.white, //Icon color
                            style: const TextStyle(
                                //te
                                color: Colors.black, //Font color
                                fontSize: 20 //font size on dropdown button
                                ),
                            dropdownColor:
                                Colors.white, //dropdown background color
                            underline: Container(), //remove underline
                          ))),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                              color: Colors.black38,
                              width: 1), //border of dropdown button
                          borderRadius: BorderRadius.circular(
                              60), //border raiuds of dropdown button
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontStyle: FontStyle.normal),
                            ),
                            onPressed: () => _selectDate(context),
                            child: const Text(
                              'Select Date',
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ))),
                const SizedBox(width: 16.0),
                Container(
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                              color: Colors.black38,
                              width: 1), //border of dropdown button
                          borderRadius: BorderRadius.circular(
                              60), //border raiuds of dropdown button
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontStyle: FontStyle.normal),
                              ),
                              onPressed: () {
                                historicalViewModel = Provider.of<
                                        HistoricalDataCurrenciesViewModel>(
                                    context,
                                    listen: false);
                                DateTime thirtyDaysFromSeleted =
                                    selectedDate!.add(const Duration(days: 30));
                                historicalViewModel.getHistoricalData(
                                    selectedCurrencyDropdown1!,
                                    selectedCurrencyDropdown2!,
                                    getFormattedDateTime(selectedDate!),
                                    getFormattedDateTime(thirtyDaysFromSeleted));
                                setState(() {
                                  onPressed = true;
                                });
                              },
                              child: const Text(
                                'Get Rates',
                                style: TextStyle(
                                    //te
                                    color: Colors.black, //Font color
                                    fontSize: 15 //font size on dropdown button
                                    ),
                              )),
                        ))),
              ],
            ),
            onPressed! && historicalViewModel.historicalCurrencyDate != null
                ? buildCurrencyChart(historicalViewModel)
                : Container(),
            Visibility(visible: selectedDate != null, child: Text('Hello'))
          ],
        ),
      ),
    );
  }

  buildCurrencyChart(HistoricalDataCurrenciesViewModel historicalViewModel) {
    return AspectRatio(
        aspectRatio: 1.40,
        child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: BarChart(
              BarChartData(
                  groupsSpace: 10,
                  alignment: BarChartAlignment.spaceBetween,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
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
                    // DateTime date =
                    // from!.add(Duration(days: touchedSpots.fromY.toInt()));
                    return BarTooltipItem(
                      "${getFormattedDateTime(DateTime.parse(historicalViewModel.historicalCurrencyDate!.startDate!))}",
                      TextStyle(color: Colors.black, fontSize: 12),
                    );
                    // }).toList();
                  })),
                  maxY: _calculateMaxY(historicalViewModel),
                  barGroups: _chartGroups(context, historicalViewModel)),
            )));
  }

  List<BarChartGroupData> _chartGroups(
      context, HistoricalDataCurrenciesViewModel viewModel) {
    return viewModel.historicalCurrencyDate!.priceData!.entries.map((point) {
      int index = 0;
      String date = point.key;
      String numericDate = date.replaceAll(RegExp(r'[^0-9]'), '');
      CurrencyData currencyData = point.value;
      List<BarChartRodData> bars = currencyData.currencies.entries.map((entry) {
        String currency = entry.key;
        PriceData priceData = entry.value;
        double barHeight = priceData.close;
        return BarChartRodData(
          color: getColor(index),
          borderRadius: BorderRadius.zero,
          toY: barHeight,
        );
      }).toList();
      index++;
      return BarChartGroupData(x: int.parse(numericDate), barRods: bars);
    }).toList();
  }

  Text getTitlesBottom(value) {
    if (value.toInt() == 0) {
      return const Text(
        'date',
        style: TextStyle(color: Colors.black54, fontSize: 12),
      );
    } else if (value.toInt() == 2) {
      return const Text(
        'date',
        style: TextStyle(color: Colors.black),
      );
    }
    return Text('');
  }

  Widget rightTitles(double value, TitleMeta meta) {
    return Text(
      '',
      style: TextStyle(color: Colors.black),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(color: Colors.black54, fontSize: 12);
    if (value.toInt() == 0) {
      return Text("0");
    } else if (value.toInt() == 2!.toInt()) {
      return Text(
        value.toStringAsFixed(0),
        style: style,
      );
    }
    return Text('');
  }

  Text getTitlesX(value) {
    if (value.toInt() == 0) {
      return Text('X');
    } else if (value.toInt() == 0) {
      return Text('to');
    }
    return Text('rr');
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

  showErrorAlert(BuildContext context, bool dateError, String? errorMessage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: dateError
              ? Text('Please select a different date')
              : Text(errorMessage ?? ''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDates(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) {
        if (date.weekday != 6 && date.weekday != 7) {
          return true;
        } else
          return false;
      },
      // selectableDayPredicate: (DateTime date) {
      //   // Disable weekends (Saturday and Sunday)
      //   return date.weekday != 6 && date.weekday != 7;
      // },
    );

    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
      });
    }
  }

  selectableDayPredicate(DateTime day) {
    return day.weekday != 6 && day.weekday != 7;
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
}
