import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final String type;
  final int expiresIn;

  const TokenModel({
    required this.accessToken,
    this.refreshToken,
    required this.type,
    required this.expiresIn,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      type: json['type'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'type': type,
      'expires_in': expiresIn,
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, type, expiresIn];
}
