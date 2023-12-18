import 'dart:convert';

class HistoricalData {
  final String? startDate;
  final String? endDate;
  final Map<String, CurrencyData>? priceData;

  HistoricalData({
    required this.startDate,
    required this.endDate,
    required this.priceData,
  });

  factory HistoricalData.fromRawJson(String str) =>
      HistoricalData.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());
  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    final Map<String, CurrencyData> price = {};
    json['price']?.forEach((date, currency) {
      price[date] = CurrencyData.fromJson(currency as Map<String, dynamic>);
    });
    return HistoricalData(
      startDate: json["start_date"],
      endDate: json["end_date"],
      priceData: price,
    );
  }

  Map<String, dynamic> toJson() => {
    "priceData": Map.from(priceData!)
        .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "start_date": startDate,
    "end_date": endDate,
  };
}

class PriceData {
    final double close;
    final double high;
    final double low;
    final double open;

    PriceData({
        required this.close,
        required this.high,
        required this.low,
        required this.open,
    });

    factory PriceData.fromJson(Map<String, dynamic> json) {
        return PriceData(
            close: json['close'] as double,
            high: json['high'] as double,
            low: json['low'] as double,
            open: json['open'] as double,
        );
    }
}

class CurrencyData {
    final String? date;
    final Map<String, PriceData> currencies;

    CurrencyData({
        required this.date,
        required this.currencies,
    });

    factory CurrencyData.fromJson(Map<String, dynamic> json) {
        final Map<String, PriceData> currencies = {};
        json.forEach((currency, data) {
            currencies[currency] = PriceData.fromJson(data as Map<String, dynamic>);
        });

        return CurrencyData(
            date: json['date'] ?? '',
            currencies: currencies,
        );
    }
}