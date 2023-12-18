import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/models/history.dart';
import 'package:currency_exchange_app/services/currency_data_services.dart';
import 'package:flutter/material.dart';

class HistoricalDataCurrenciesViewModel extends ChangeNotifier {
  final HistoricalDataService? _repository;

  FetchState _historyCurrenciesFetchState = FetchState.not_fetched;
  bool _isRefreshing = false;
  String? _errorMessage;

  HistoricalData? _historicalData;

  HistoricalDataCurrenciesViewModel({
    required HistoricalDataService repository,
  }) : _repository = repository;


  Future<HistoricalData?> getHistoricalData(String baseCurrency,
      String targetCurrency, String startDate, String endDate) async {
    _historyCurrenciesFetchState = FetchState.fetching;
    notifyListeners();
    try {
      _historicalData = await _repository!
          .getHistoricalData(baseCurrency, targetCurrency, startDate, endDate);
      _historyCurrenciesFetchState = FetchState.done;
      notifyListeners();
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _historyCurrenciesFetchState = FetchState.errored;
      notifyListeners();
    }

    return _historicalData;
  }

  HistoricalData? get historicalCurrencyDate => _historicalData;
  FetchState get historyCurrenciesFetchState => _historyCurrenciesFetchState;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage =>
    historyCurrenciesFetchState == FetchState.errored
        ? _errorMessage
        : null;
}
