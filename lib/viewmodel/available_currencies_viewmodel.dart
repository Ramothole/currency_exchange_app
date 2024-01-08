import 'package:currency_exchange_app/core/states_management.dart';
import 'package:currency_exchange_app/models/available_currencies.dart';
import 'package:currency_exchange_app/services/currency_data_services.dart';
import 'package:flutter/material.dart';

class AvailableCurrenciesViewModel extends ChangeNotifier {
  final HistoricalDataService? _repository;

  FetchState _availableCurrenciesFetchState = FetchState.not_fetched;
  bool _isRefreshing = false;
  String? _errorMessage;
  AvailableCurrencies? _availablecurrencies;

  AvailableCurrenciesViewModel({
    required HistoricalDataService repository,
  }) : _repository = repository;

  Future<AvailableCurrencies?> getAvailableCurrencies() async {
    _availableCurrenciesFetchState = FetchState.fetching;
    notifyListeners();
    try {
      _availablecurrencies = await _repository!.getAvailableCurrencies();
      _availableCurrenciesFetchState = FetchState.done;
      notifyListeners();
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _availableCurrenciesFetchState = FetchState.errored;
      notifyListeners();
    }

    return _availablecurrencies;
  }

  AvailableCurrencies? get availableCurrencies => _availablecurrencies;
  FetchState get availableCurrenciesFetchState =>
      _availableCurrenciesFetchState;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage =>
      availableCurrenciesFetchState == FetchState.errored
          ? _errorMessage
          : null;
}
