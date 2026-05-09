import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'api_exception.dart';
import '../network/network_checker.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String endpoint) async {
    return _request(() async {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      log('GET REQUEST: $uri', name: 'API');
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(
            const Duration(milliseconds: ApiConstants.connectionTimeout),
          );
      log(
        'GET RESPONSE [${response.statusCode}]: ${response.body}',
        name: 'API',
      );
      return response;
    });
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    return _request(() async {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      log(' POST REQUEST: $uri', name: 'API');
      log('POST BODY: ${jsonEncode(body)}', name: 'API');
      final response = await _client
          .post(uri, headers: _headers, body: jsonEncode(body))
          .timeout(
            const Duration(milliseconds: ApiConstants.connectionTimeout),
          );
      log(
        ' POST RESPONSE [${response.statusCode}]: ${response.body}',
        name: 'API',
      );
      return response;
    });
  }

  Future<dynamic> _request(Future<http.Response> Function() requestFunc) async {
    bool hasInternet = await NetworkChecker.isConnected();
    if (!hasInternet) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await requestFunc();
      return _processResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timed out');
    } on FormatException {
      throw ApiException('Invalid JSON response');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error occurred: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw ApiException(
        'Empty response from server',
        statusCode: response.statusCode,
      );
    }

    dynamic responseJson;
    try {
      responseJson = jsonDecode(response.body);
    } catch (e) {
      throw ApiException(
        'Invalid JSON response',
        statusCode: response.statusCode,
      );
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 404:
        throw ApiException('Resource not found', statusCode: 404);
      case 500:
        throw ApiException('Internal Server Error', statusCode: 500);
      default:
        final msg = (responseJson is Map && responseJson['message'] != null)
            ? responseJson['message']
            : 'Error occurred while communicating with server';
        throw ApiException(msg, statusCode: response.statusCode);
    }
  }
}
