import 'package:currency_exchange_app/core/date_format.dart';
import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/services/currency_data_services.dart';
import 'package:currency_exchange_app/viewmodel/currency_rate_viewmodel.dart';
import 'package:currency_exchange_app/views/check_currency_exchange.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentRateScreen extends StatefulWidget {
  const CurrentRateScreen({super.key});

  @override
  State<CurrentRateScreen> createState() => _CurrentRateScreenState();
}

class _CurrentRateScreenState extends State<CurrentRateScreen> {

@override
  // void initState() {
  //   Provider.of<CurrencyViewModel>(context, listen: false).getCurrencies();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyViewModel>(
        builder: (context, viewModel, child) {
        return Scaffold(
              appBar: AppBar(
                title: const Text('Currency'),
                centerTitle: true,
                backgroundColor: Colors.red[600],
              ),
              body: states(viewModel),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  viewModel.getCurrencies();
                },
                child: Icon(Icons.refresh),
              ),
            );
      }
    );
  }

  states(CurrencyViewModel viewModel){
    if(viewModel.rateCurrencyState == FetchState.fetching){
     return const Center(child: CircularProgressIndicator());
    }
    if(viewModel.rateCurrencyState == FetchState.done){
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.currencyRate?.price.entries.toList().length,
            itemBuilder: (BuildContext context, int index) {
              final suggestion = viewModel.currencyRate?.price.entries.toList()[index];
              return Container(
                height: 50,
                child: Card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(suggestion!.key))),
                      Container(
                          padding: EdgeInsets.only(right: 12),
                          child: Text(suggestion.value.toString())),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }
  }

  String formatData(Map<String, double>? data) {
    List<String> pairs =
        data!.entries.map((entry) => '${entry.key}: ${entry.value}').toList();
    return pairs.join(', ');
  }
}
