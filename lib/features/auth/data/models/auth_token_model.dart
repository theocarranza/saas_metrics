import 'dart:convert';
import 'package:saas_metrics/features/auth/domain/entities/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.value,
    required super.expiry,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'expiry': expiry.millisecondsSinceEpoch,
    };
  }

  factory AuthTokenModel.fromMap(Map<String, dynamic> map) {
    return AuthTokenModel(
      value: map['value'] as String,
      expiry: DateTime.fromMillisecondsSinceEpoch(map['expiry'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthTokenModel.fromJson(String source) =>
      AuthTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);
  
  factory AuthTokenModel.fromEntity(AuthToken token) {
    return AuthTokenModel(
      value: token.value, 
      expiry: token.expiry,
    );
  }
}
