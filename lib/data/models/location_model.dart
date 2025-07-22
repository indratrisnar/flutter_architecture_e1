import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const LocationModel({
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object> get props => [address, city, country, latitude, longitude];
}
