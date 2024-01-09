import 'package:currency_exchange_app/services/currency_data_services.dart';
import 'package:currency_exchange_app/viewmodel/available_currencies_viewmodel.dart';
import 'package:currency_exchange_app/viewmodel/currency_rate_viewmodel.dart';
import 'package:currency_exchange_app/views/check_currency_exchange.dart';
import 'package:currency_exchange_app/views/current_rate_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  AvailableCurrenciesViewModel? availableCurrenciesViewModel;
  CurrencyViewModel? viewModel;
  @override
  void initState() {
     viewModel = Provider.of<CurrencyViewModel>(context, listen: false);
     availableCurrenciesViewModel = Provider.of<AvailableCurrenciesViewModel>(context,listen: false);
    viewModel?.getCurrencies();
    availableCurrenciesViewModel?.getAvailableCurrencies();
    super.initState();
  }
  final List<Widget> _pages = [
    const CurrentRateScreen(),
    const HistoricalExchangeRate(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CurrencyViewModel(
      repository:  HistoricalDataService(),
    ),
    child: Scaffold(
      backgroundColor:Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange_outlined),
            label: 'Current Rate Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Bar Chart',
          ),
        ],
      ),
      body: _pages.elementAt(_currentIndex),
    )
        );
  }

  void  _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
