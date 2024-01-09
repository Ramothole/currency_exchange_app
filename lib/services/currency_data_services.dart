import 'dart:convert';
import 'dart:io';
import 'package:currency_exchange_app/models/available_currencies.dart';
import 'package:currency_exchange_app/models/currency_rate.dart';
import 'package:currency_exchange_app/models/history.dart';
import 'package:http/http.dart' as http;

class HistoricalDataService {
  Future<HistoricalData?> getHistoricalData(
    String baseCurrency,
    String targetCurrency,
    String startDate,
    String endDate,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://fxmarketapi.com/apitimeseries?'
        'currency=$baseCurrency,$targetCurrency'
        '&start_date=$startDate&end_date=$endDate'
        '&interval=daily&api_key=J93CgSzx5DtI6-FrsaPI',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
            return HistoricalData.fromRawJson(response.body);
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      dynamic errorMessage = json.decode(response.body);
      throw errorMessage;
    }
  }

  Future<AvailableCurrencies?> getAvailableCurrencies() async {
    final response = await http.get(
      Uri.parse(
          'https://fxmarketapi.com/apicurrencies?api_key=J93CgSzx5DtI6-FrsaPI'),
    );
    if (response.statusCode == HttpStatus.ok) {
      return AvailableCurrencies.fromRawJson(response.body);
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      dynamic errorMessage = json.decode(response.body);
      throw errorMessage;
    }
  }

  Future<CurrencyRate?> getCurrencyData() async {
    final response = await http.get(
      Uri.parse('https://fxmarketapi.com/apilive?api_key=J93CgSzx5DtI6-FrsaPI'),
    );
    if (response.statusCode == HttpStatus.ok) {
      return CurrencyRate.fromRawJson(response.body);
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      dynamic errorMessage = json.decode(response.body);
      throw errorMessage;
    }
  }
}
