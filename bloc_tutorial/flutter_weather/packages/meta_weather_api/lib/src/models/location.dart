import 'package:json_annotation/json_annotation.dart';

// part 'location.g.dart';

enum LocationType {
  @JsonValue('City')
  city,
  @JsonValue('Region')
  region,
  @JsonValue('State')
  state,
  @JsonValue('Province')
  province,
  @JsonValue('Country')
  country,
  @JsonValue('Continent')
  continent
}

extension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
}

extension on LocationType {
  String get inString => this.toString().split('.').last.inCaps;
}

@JsonSerializable()
class Location {
  final String title;
  final LocationType locationType;
  @JsonKey(name: 'latt_long')
  @LatLngConverter()
  final LatLng latLng;
  final int woeid;

  const Location({
    required this.title,
    required this.locationType,
    required this.latLng,
    required this.woeid,
  });


  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      title: json["title"],
      locationType: locationTypeFromString(json["locationType"]),
      latLng: LatLngConverter().fromJson(json["latLng"]),
      woeid: int.parse(json["woeid"] ?? '0'),
    );
  }

  static LocationType locationTypeFromString(String? value) {
    return value == null
        ? LocationType.city
        : LocationType.values
            .firstWhere((element) => element.inString == value);
  }
//

}

class LatLng {
  const LatLng({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class LatLngConverter implements JsonConverter<LatLng, String> {
  const LatLngConverter();

  @override
  String toJson(LatLng latLng) {
    return '${latLng.latitude},${latLng.longitude}';
  }

  @override
  LatLng fromJson(String? jsonString) {
    if(jsonString == null) {
      return LatLng(latitude: 0, longitude: 0);
    }
    final parts = jsonString.split(',');
    return LatLng(
      latitude: double.tryParse(parts[0]) ?? 0,
      longitude: double.tryParse(parts[1]) ?? 0,
    );
  }
}
