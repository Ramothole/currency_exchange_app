import 'package:currency_exchange_app/services/currency_data_services.dart';
import 'package:currency_exchange_app/viewmodel/available_currencies_viewmodel.dart';
import 'package:currency_exchange_app/viewmodel/currency_rate_viewmodel.dart';
import 'package:currency_exchange_app/viewmodel/historical_currency_data.dart';
import 'package:currency_exchange_app/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AvailableCurrenciesViewModel(repository: HistoricalDataService()),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrencyViewModel(repository: HistoricalDataService()),
        ),
        ChangeNotifierProvider(
        create: (context) => HistoricalDataCurrenciesViewModel(repository: HistoricalDataService()),
  ),],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
