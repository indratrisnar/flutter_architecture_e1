import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_architecture_e1/core/errors/exceptions.dart';
import 'package:flutter_architecture_e1/data/data_sources/local/session_local_data_source.dart';
import 'package:flutter_architecture_e1/data/models/destination_model.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

abstract class DestinationRemoteDataSource {
  Future<List<DestinationModel>> fetchPopular();
}

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  static final _logger = Logger('DestinationRemoteDataSourceImpl');
  static const _baseURL = 'https://fdelux.globeapp.dev/api/destinations';

  final http.Client _client;
  final SessionLocalDataSource _sessionLocalDataSource;

  DestinationRemoteDataSourceImpl({
    required http.Client client,
    required SessionLocalDataSource sessionLocalDataSource,
  }) : _sessionLocalDataSource = sessionLocalDataSource,
       _client = client;

  Future<String> _getBearerToken() async {
    _logger.info('Attempting to retrieve bearer token.');
    final tokenModel = await _sessionLocalDataSource.getAuthToken();
    if (tokenModel == null || tokenModel.accessToken.isEmpty) {
      _logger.warning('Authentication token missing or empty.');
      throw const UnauthenticatedException(
        message: 'Authentication token missing.',
      );
    }
    _logger.info('Bearer token retrieved successfully.');
    return 'Bearer ${tokenModel.accessToken}';
  }

  @override
  Future<List<DestinationModel>> fetchPopular() async {
    _logger.info('Fetching popular destinations...');
    try {
      const endpoint = '$_baseURL/popular';
      _logger.fine('Requesting endpoint: $endpoint');

      final requestHeader = {
        'Content-Type': 'application/json',
        'Authorization': await _getBearerToken(),
      };

      final response = await _client.get(
        Uri.parse(endpoint),
        headers: requestHeader,
      );

      final responseBody = jsonDecode(response.body);
      final statusCode = response.statusCode;

      _logger.info(
        'Received response for $endpoint with status code: $statusCode',
      );
      _logger.fine('Response body: ${response.body}');

      if (statusCode == 200) {
        final destinationsJson =
            responseBody['data']['destinations'] as List<dynamic>;
        _logger.fine('Parsing popular destinations JSON array...');
        final destinations = await compute(
          _parseJsonArrayDestinations,
          destinationsJson,
        );
        _logger.info(
          'Successfully fetched and parsed ${destinations.length} popular destinations.',
        );
        return destinations;
      }

      String errorMessage =
          responseBody['message'] ?? 'An unknown error occurred.';
      _logger.warning(
        'Server responded with error: $errorMessage (Status: $statusCode), Body: ${response.body}',
      );

      if (statusCode == 401) {
        throw UnauthenticatedException(
          message: errorMessage,
          statusCode: statusCode,
        );
      }

      _logger.severe(
        'Failed to fetch popular destinations. Status code: $statusCode, Body: ${response.body}',
      );
      throw ServerException(
        message:
            'Failed to fetch popular destinations. Status code: $statusCode, Body: ${response.body}',
        statusCode: statusCode,
        error: response.body,
      );
    } on http.ClientException catch (e, st) {
      _logger.severe('Network error during fetchPopular: ${e.message}', e, st);
      throw NetworkException(message: 'Network error: ${e.message}', error: e);
    } on FormatException catch (e, st) {
      _logger.severe(
        'Data parsing error (FormatException) during fetchPopular: ${e.message}',
        e,
        st,
      );
      throw DataParsingException(
        message: 'Invalid response format from server: ${e.message}',
        error: e,
      );
    } on TypeError catch (e, st) {
      _logger.severe(
        'Unexpected data type (TypeError) during parsing: ${e.toString()}',
        e,
        st,
      );
      throw DataParsingException(
        message: 'Unexpected data type during parsing: ${e.toString()}',
        error: e,
      );
    } catch (e, st) {
      _logger.shout('An unexpected error occurred during fetchPopular.', e, st);
      rethrow;
    }
  }
}

// This function runs in an isolate, so it won't have direct access to a Logger instance
// initialized in the main isolate. For simplicity, we'll keep a simple debugPrint here.
List<DestinationModel> _parseJsonArrayDestinations(
  List<dynamic> jsonArrayDestinations,
) {
  debugPrint(
    '💡 LOG: Background parsing of destination array started in isolate.',
  );
  final parsedDestinations = jsonArrayDestinations
      .map((item) => DestinationModel.fromJson(item as Map<String, dynamic>))
      .toList();
  debugPrint(
    '💡 LOG: Background parsing of destination array completed in isolate.',
  );
  return parsedDestinations;
}
