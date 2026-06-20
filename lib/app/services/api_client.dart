import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:parela/app/services/storage_service.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  ApiException({required this.statusCode, required this.message, this.errors});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static const _baseUrl = 'https://palera-server.test/api';

  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();

  late final http.Client _client;

  ApiClient._() {
    _client = _buildClient();
  }

  // Trusts the self-signed TLS cert on the local dev server.
  // Scoped to palera-server.test only — does not bypass cert validation globally.
  static http.Client _buildClient() {
    final inner = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) =>
          host == 'palera-server.test';
    return IOClient(inner);
  }

  Map<String, String> _headers({bool auth = true}) {
    final h = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };
    if (auth) {
      final token = StorageService.instance.accessToken;
      if (token != null) h[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return h;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final q = query?.map((k, v) => MapEntry(k, v.toString()));
    return Uri.parse('$_baseUrl$path').replace(queryParameters: q?.isEmpty == true ? null : q);
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query, bool auth = true}) async {
    _logRequest('GET', path, query: query);
    final res = await _client.get(_uri(path, query), headers: _headers(auth: auth));
    return _handle(res, method: 'GET', path: path, auth: auth, retry: () => get(path, query: query, auth: auth));
  }

  Future<Map<String, dynamic>> post(String path, {Object? body, bool auth = true}) async {
    _logRequest('POST', path, body: body);
    final res = await _client.post(_uri(path), headers: _headers(auth: auth),
        body: body != null ? json.encode(body) : null);
    return _handle(res, method: 'POST', path: path, auth: auth, retry: () => post(path, body: body, auth: auth));
  }

  Future<Map<String, dynamic>> put(String path, {Object? body, bool auth = true}) async {
    _logRequest('PUT', path, body: body);
    final res = await _client.put(_uri(path), headers: _headers(auth: auth),
        body: body != null ? json.encode(body) : null);
    return _handle(res, method: 'PUT', path: path, auth: auth, retry: () => put(path, body: body, auth: auth));
  }

  Future<Map<String, dynamic>> delete(String path, {bool auth = true}) async {
    _logRequest('DELETE', path);
    final res = await _client.delete(_uri(path), headers: _headers(auth: auth));
    return _handle(res, method: 'DELETE', path: path, auth: auth, retry: () => delete(path, auth: auth));
  }

  Future<Map<String, dynamic>> _handle(
    http.Response res, {
    required String method,
    required String path,
    required bool auth,
    required Future<Map<String, dynamic>> Function() retry,
  }) async {
    final body = json.decode(res.body) as Map<String, dynamic>;
    _logResponse(method, path, res.statusCode, body);

    if (res.statusCode == 401 && auth) {
      final refreshed = await _refresh();
      if (refreshed) return retry();
    }

    if (res.statusCode >= 200 && res.statusCode < 300) return body;

    throw ApiException(
      statusCode: res.statusCode,
      message: body['message'] as String? ?? 'Unknown error',
      errors: body['errors'] as Map<String, dynamic>?,
    );
  }

  static void _logRequest(String method, String path, {Object? body, Map<String, dynamic>? query}) {
    if (!kDebugMode) return;
    final q = query != null && query.isNotEmpty ? '?$query' : '';
    dev.log('→ $method $path$q${body != null ? '\n  body: ${json.encode(body)}' : ''}',
        name: 'ApiClient');
  }

  static void _logResponse(String method, String path, int status, Map<String, dynamic> body) {
    if (!kDebugMode) return;
    final ok = status >= 200 && status < 300;
    final prefix = ok ? '← $status' : '✗ $status';
    dev.log('$prefix $method $path\n  ${json.encode(body)}', name: 'ApiClient');
  }

  Future<bool> _refresh() async {
    final refreshToken = StorageService.instance.refreshToken;
    if (refreshToken == null) return false;
    try {
      final res = await _client.post(
        _uri('/auth/refresh'),
        headers: _headers(auth: false),
        body: json.encode({'refresh_token': refreshToken}),
      );
      if (res.statusCode == 200) {
        final data = (json.decode(res.body) as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        await StorageService.instance.saveTokens(
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] as String,
        );
        return true;
      }
    } catch (_) {}
    await StorageService.instance.clearTokens();
    return false;
  }
}
