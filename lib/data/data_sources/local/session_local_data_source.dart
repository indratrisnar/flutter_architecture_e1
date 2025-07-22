import 'package:flutter_architecture_e1/core/errors/exceptions.dart';
import 'package:flutter_architecture_e1/data/models/token_model.dart';
import 'package:flutter_architecture_e1/data/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class SessionLocalDataSource {
  static const String kSessionBoxName = 'session_box';

  Future<void> cacheAuthToken(TokenModel tokenModel);
  Future<TokenModel?> getAuthToken();
  Future<void> cacheUserData(UserModel user);
  Future<UserModel?> getUserData();
  Future<void> clearSession();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  static const _tokenKey = 'cached_token_key';
  static const _userKey = 'cached_user_key';

  final Box<dynamic> _sessionBox;

  const SessionLocalDataSourceImpl({required Box<dynamic> sessionBox})
    : _sessionBox = sessionBox;

  @override
  Future<void> cacheAuthToken(TokenModel tokenModel) async {
    try {
      await _sessionBox.put(_tokenKey, tokenModel.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache auth token: ${e.toString()}',
        error: e,
      );
    }
  }

  @override
  Future<TokenModel?> getAuthToken() async {
    try {
      final jsonMap = _sessionBox.get(_tokenKey);
      if (jsonMap != null && jsonMap is Map) {
        return TokenModel.fromJson(Map.from(jsonMap));
      }
      return null;
    } on FormatException catch (e) {
      throw DataParsingException(
        message: 'Corrupted token data in cache: ${e.message}',
        error: e,
      );
    } on TypeError catch (e) {
      throw DataParsingException(
        message: 'Corrupted token data type in cache: ${e.toString()}',
        error: e,
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to get auth token: ${e.toString()}',
        error: e,
      );
    }
  }

  @override
  Future<void> cacheUserData(UserModel user) async {
    try {
      await _sessionBox.put(_userKey, user.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache user data: ${e.toString()}',
        error: e,
      );
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      final jsonMap = _sessionBox.get(_userKey);
      if (jsonMap != null && jsonMap is Map) {
        return UserModel.fromJson(Map.from(jsonMap));
      }
      return null;
    } on FormatException catch (e) {
      throw DataParsingException(
        message: 'Corrupted user data in cache: ${e.message}',
        error: e,
      );
    } on TypeError catch (e) {
      throw DataParsingException(
        message: 'Corrupted user data type in cache: ${e.toString()}',
        error: e,
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user data from cache: ${e.toString()}',
        error: e,
      );
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await Future.wait([
        _sessionBox.delete(_tokenKey),
        _sessionBox.delete(_userKey),
      ]);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear session: ${e.toString()}',
        error: e,
      );
    }
  }
}
