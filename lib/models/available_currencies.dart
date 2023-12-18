import 'dart:convert';

class AvailableCurrencies {
    final Map<String, String> currencies;

    AvailableCurrencies({
        required this.currencies,
    });

    factory AvailableCurrencies.fromRawJson(String str) => AvailableCurrencies.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AvailableCurrencies.fromJson(Map<String, dynamic> json) => AvailableCurrencies(
        currencies: Map.from(json["currencies"]).map((k, v) => MapEntry<String, String>(k, v)),
    );

    Map<String, dynamic> toJson() => {
        "currencies": Map.from(currencies).map((k, v) => MapEntry<String, String>(k, v)),
    };
}
