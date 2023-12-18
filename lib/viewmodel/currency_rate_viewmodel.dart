import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/models/currency_rate.dart';
import 'package:currency_exchange_app/services/currency_data_services.dart';
import 'package:flutter/material.dart';

class CurrencyViewModel extends ChangeNotifier {
  final HistoricalDataService? _repository;

  FetchState _rateFetchState = FetchState.not_fetched;
  bool _isRefreshing = false;
  String? _errorMessage;

  CurrencyRate? _currencyRate;


  CurrencyViewModel({
    required HistoricalDataService repository,
  }) : _repository = repository;


 Future<CurrencyRate?> getCurrencies() async {
    _rateFetchState = FetchState.fetching;
    notifyListeners();
    try {
      _currencyRate = await _repository!.getCurrencyData();
      _rateFetchState = FetchState.done;
      notifyListeners();
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _rateFetchState = FetchState.errored;
      notifyListeners();
    }

    return _currencyRate;
  }

  CurrencyRate? get currencyRate => _currencyRate;
    FetchState get rateCurrencyState => _rateFetchState;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage =>
      rateCurrencyState == FetchState.errored ? _errorMessage : null;

}
