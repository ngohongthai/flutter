import 'dart:convert';
import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;
  PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  PlaceLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return PlaceLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory PlaceLocation.fromMap(Map<String, dynamic> map) {
    return PlaceLocation(
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceLocation.fromJson(String source) =>
      PlaceLocation.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlaceLocation(latitude: $latitude, longitude: $longitude, address: $address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceLocation &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ address.hashCode;
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;
  Place({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
  });

  Place copyWith({
    String? id,
    String? title,
    PlaceLocation? location,
    File? image,
  }) {
    return Place(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      image: image ?? this.image,
    );
  }
}
