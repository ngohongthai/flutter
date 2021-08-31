import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';


enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

extension on WeatherCondition {
  String get inString => this.toString().split('.').last;
}

@JsonSerializable()
class Weather extends Equatable {
  final String location;
  final double temperature;
  final WeatherCondition condition;

  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
  });

  static WeatherCondition weatherConditionFromString(String? value) {
    if (value == null) {
      return WeatherCondition.unknown;
    }
    return WeatherCondition.values
            .firstWhere((element) => element.inString == value);
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json["location"],
      temperature: double.parse(json["temperature"]),
      condition: Weather.weatherConditionFromString(json["condition"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "location": this.location,
      "temperature": this.temperature,
      "condition": this.condition.inString,
    };
  }

  String weatherConditionToString(WeatherCondition weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.clear:
        return "clear";
      default:
        return "unknown";
    }
  }

  @override
  List<Object> get props => [location, temperature, condition];
}
