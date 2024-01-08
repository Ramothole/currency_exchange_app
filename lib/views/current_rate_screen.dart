import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/viewmodel/currency_rate_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentRateScreen extends StatefulWidget {
  const CurrentRateScreen({super.key});

  @override
  State<CurrentRateScreen> createState() => _CurrentRateScreenState();
}

class _CurrentRateScreenState extends State<CurrentRateScreen> {
  @override
  void initState() {
    Provider.of<CurrencyViewModel>(context, listen: false).getCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        body: states(viewModel),
      );
    });
  }

  states(CurrencyViewModel viewModel) {
    if (viewModel.rateCurrencyState == FetchState.fetching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.rateCurrencyState == FetchState.done) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount:
                    viewModel.currencyRate?.price.entries.toList().length,
                itemBuilder: (BuildContext context, int index) {
                  final suggestion =
                      viewModel.currencyRate?.price.entries.toList()[index];
                  return Container(
                    height: 50,
                    child: Container(
                      color:  Colors.grey[200],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 12, top: 12),
                                  child: Text(suggestion!.key))),
                          Container(
                              padding: const EdgeInsets.only(right: 12),
                              child: Center(
                                  child: Text(
                                suggestion.value.toString(),
                                textAlign: TextAlign.start,
                              ))),
                              const Divider(height: 2,color: Colors.black,)
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
