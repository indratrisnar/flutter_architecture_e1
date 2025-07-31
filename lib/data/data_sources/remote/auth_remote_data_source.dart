import 'dart:convert';

import 'package:flutter_architecture_e1/core/errors/exceptions.dart';
import 'package:flutter_architecture_e1/data/models/token_model.dart';
import 'package:flutter_architecture_e1/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel, TokenModel)> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static final _logger = Logger('AuthRemoteDataSourceImpl');
  static const _baseURL = 'https://fdelux.globeapp.dev/api';

  final http.Client _client;

  const AuthRemoteDataSourceImpl({required http.Client client})
    : _client = client;

  @override
  Future<(UserModel, TokenModel)> login(String email, String password) async {
    _logger.info('Attempting to log in user: $email');
    try {
      const endpoint = '$_baseURL/login';
      final requestHeader = {'Content-Type': 'application/json'};
      final requestBody = jsonEncode({'email': email, 'password': password});
      _logger.fine('Login request to $endpoint with body: $requestBody');

      final response = await _client.post(
        Uri.parse(endpoint),
        headers: requestHeader,
        body: requestBody,
      );

      final responseBody = jsonDecode(response.body);
      final statusCode = response.statusCode;
      final errorMessage =
          responseBody['message'] ?? 'An unknown error occurred.';

      _logger.fine(
        'Login response status: $statusCode, body: ${response.body}',
      );

      if (statusCode == 200) {
        _logger.info('Login successful for user: $email');
        final userJson = responseBody['data']['user'] as Map<String, dynamic>;
        final tokenJson = responseBody['data']['token'] as Map<String, dynamic>;

        final user = UserModel.fromJson(userJson);
        final token = TokenModel.fromJson(tokenJson);

        return (user, token);
      }
      _logger.warning(
        'Login failed for user: $email. Status: $statusCode, Message: $errorMessage',
      );

      if (statusCode == 400) {
        throw BadRequestException(
          message: errorMessage,
          statusCode: statusCode,
        );
      }

      if (statusCode == 401) {
        throw UnauthenticatedException(
          message: errorMessage,
          statusCode: statusCode,
        );
      }

      if (statusCode == 404) {
        throw NotFoundException(message: errorMessage, statusCode: statusCode);
      }

      if (statusCode == 409) {
        throw ConflictException(message: errorMessage, statusCode: statusCode);
      }

      throw ServerException(
        message:
            'Login failed. Status code: $statusCode. Message: $errorMessage',
        statusCode: statusCode,
        error: errorMessage,
      );
    } on http.ClientException catch (e, st) {
      _logger.severe(
        'Network error during login for $email: ${e.message}',
        e,
        st,
      );
      throw NetworkException(
        message: 'Network error during login: ${e.message}',
        error: e,
      );
    } on FormatException catch (e, st) {
      _logger.severe(
        'Data parsing error during login for $email: ${e.message}',
        e,
        st,
      );
      throw DataParsingException(
        message: 'Invalid response format during login: ${e.message}',
        error: e,
      );
    } on TypeError catch (e, st) {
      _logger.severe(
        'Unexpected data type during login parsing for $email: ${e.toString()}',
        e,
        st,
      );
      throw DataParsingException(
        message: 'Unexpected data type during login parsing: ${e.toString()}',
        error: e,
      );
    } catch (e, st) {
      _logger.severe(
        'An unexpected error occurred during login for $email: ${e.toString()}',
        e,
        st,
      );
      rethrow;
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    _logger.info('Attempting to register new user: $email (Name: $name)');
    try {
      const endpoint = '$_baseURL/register';
      final requestHeader = {'Content-Type': 'application/json'};
      final requestBody = jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      });
      _logger.fine('Register request to $endpoint with body: $requestBody');

      final response = await _client.post(
        Uri.parse(endpoint),
        headers: requestHeader,
        body: requestBody,
      );

      final responseBody = jsonDecode(response.body);
      final statusCode = response.statusCode;
      final errorMessage =
          responseBody['message'] ?? 'An unknown error occurred.';

      _logger.fine(
        'Register response status: $statusCode, body: ${response.body}',
      );

      if (statusCode == 201) {
        _logger.info('Registration successful for user: $email');
        final userJson = responseBody['data']['user'] as Map<String, dynamic>;
        return UserModel.fromJson(userJson);
      }

      _logger.warning(
        'Registration failed for user: $email. Status: $statusCode, Message: $errorMessage',
      );

      if (statusCode == 400) {
        throw BadRequestException(
          message: errorMessage,
          statusCode: statusCode,
        );
      }

      if (statusCode == 404) {
        throw NotFoundException(message: errorMessage, statusCode: statusCode);
      }

      if (statusCode == 409) {
        throw ConflictException(message: errorMessage, statusCode: statusCode);
      }

      throw ServerException(
        message:
            'Registration failed. Status code: $statusCode. Message: $errorMessage',
        statusCode: statusCode,
        error: errorMessage,
      );
    } on http.ClientException catch (e, st) {
      _logger.severe(
        'Network error during registration for $email: ${e.message}',
        e,
        st,
      );
      throw NetworkException(
        message: 'Network error during registration: ${e.message}',
        error: e,
      );
    } on FormatException catch (e, st) {
      _logger.severe(
        'Data parsing error during registration for $email: ${e.message}',
        e,
        st,
      );
      throw DataParsingException(
        message: 'Invalid response format during registration: ${e.message}',
        error: e,
      );
    } on TypeError catch (e, st) {
      _logger.severe(
        'Unexpected data type during registration parsing for $email: ${e.toString()}',
        e,
        st,
      );
      throw DataParsingException(
        message:
            'Unexpected data type during registration parsing: ${e.toString()}',
        error: e,
      );
    } catch (e, st) {
      _logger.severe(
        'An unexpected error occurred during registration for $email: ${e.toString()}',
        e,
        st,
      );
      rethrow;
    }
  }
}
