import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? city;
  final String? address;
  final String? postalCode;
  final String? photoUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.city,
    this.address,
    this.postalCode,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      city: json['city'],
      address: json['address'],
      postalCode: json['postal_code'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'city': city,
      'address': address,
      'postal_code': postalCode,
      'photo_url': photoUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phoneNumber,
    city,
    address,
    postalCode,
    photoUrl,
  ];
}
