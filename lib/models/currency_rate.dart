import 'dart:convert';

class CurrencyRate {
    final Map<String, double> price;
    final int timestamp;

    CurrencyRate({
        required this.price,
        required this.timestamp,
    });

    factory CurrencyRate.fromRawJson(String str) => CurrencyRate.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CurrencyRate.fromJson(Map<String, dynamic> json) => CurrencyRate(
        price: Map.from(json["price"]).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
        timestamp: json["timestamp"],
    );

    Map<String, dynamic> toJson() => {
        "price": Map.from(price).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "timestamp": timestamp,
    };
}
