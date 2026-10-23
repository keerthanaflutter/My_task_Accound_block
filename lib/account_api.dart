import 'dart:convert';

import 'package:http/http.dart' as http;

/// Same backend as the app's `ApiConfig`. Override with
/// `--dart-define=API_BASE_URL=…` to point at a dev server.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://sdec-erp-backend-8xc9.onrender.com/api',
);

/// Signs in, then DELETE /api/auth/account. Returns null on success, or a
/// message fit to show the user.
Future<String?> deleteAccount(http.Client client, String email, String password) async {
  try {
    final login = await _send(client, 'POST', '/auth/login', {'email': email, 'password': password});
    if (login.status == 401) return 'Invalid email or password. Please try again.';
    final token = login.body['token'];
    if (token is! String) return _message(login.body) ?? 'Sign-in failed. Please try again.';

    final del = await _send(client, 'DELETE', '/auth/account', {'password': password}, token: token);
    if (del.status == 200) return null;
    return _message(del.body) ?? 'Failed to delete account. Please try again.';
  } catch (_) {
    return 'Could not reach the server. Check your connection and try again.';
  }
}

Future<({int status, Map<String, dynamic> body})> _send(
  http.Client client,
  String method,
  String path,
  Map<String, dynamic> data, {
  String? token,
}) async {
  final req = http.Request(method, Uri.parse('$apiBaseUrl$path'))
    ..headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    })
    ..body = jsonEncode(data);
  final res = await http.Response.fromStream(await client.send(req));
  Map<String, dynamic> body = const {};
  try {
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) body = decoded;
  } catch (_) {}
  return (status: res.statusCode, body: body);
}

/// The backend sends `{error}` on failures, `{message}` on some others.
String? _message(Map<String, dynamic> body) {
  for (final key in ['error', 'message']) {
    final v = body[key];
    if (v is String && v.trim().isNotEmpty) return v;
  }
  return null;
}
