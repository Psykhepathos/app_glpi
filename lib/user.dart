import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  String _login = '';
  String _password = '';
  bool _isLoading = false;
  String _sessionToken = '';
  final storage = const FlutterSecureStorage();

  String get login => _login;
  String get password => _password;
  bool get isLoading => _isLoading;
  String get sessionToken => _sessionToken;

  // Private constructor
  UserProvider._();

  static Future<UserProvider> create() async {
    final provider = UserProvider._();

    return provider;
  }

  void setLogin(String login) {
    _login = login;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setSessionToken(String token) {
    _sessionToken = token;
    notifyListeners();
  }

  void clearSessionToken() {
    _sessionToken = '';
    notifyListeners();
  }

  Future<bool> loginUser() async {
    String auth = '${_login}:${_password}';
    String encodedAuth = base64.encode(utf8.encode(auth));
    var headers = {'Authorization': 'Basic $encodedAuth'};
    var request = http.Request(
        'GET', Uri.parse('http://192.168.1.18/apirest.php/initSession/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      _sessionToken = jsonDecode(responseBody)['session_token'];
      await storage.write(key: 'session_token', value: _sessionToken);

      return true;
    } else {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> errorJson = jsonDecode(responseBody);
      String errorMessage = errorJson[1];
      return Future.error(errorMessage);
    }
  }

  Future<Map<String, dynamic>?> getTicketData() async {
    var headers = {'Session-Token': _sessionToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://192.168.1.18/apirest.php/search/ticket?criteria[0][link]=AND NOT&criteria[0][field]=12&criteria[0][searchtype]=equals&criteria[0][value]=6&criteria[1][link]=AND&criteria[1][field]=5&criteria[1][searchtype]=equals&criteria[1][value]=497&uid_cols=true'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }

  Future<void> updateTicket(int id, String name) async {
    final headers = {
      'Session-Token': _sessionToken,
      'Content-Type': 'application/json'
    };
    final request = http.Request(
      'PUT',
      Uri.parse('http://192.168.1.18/apirest.php/Ticket/'),
    );
    request.body = json.encode({
      "input": {
        "id": id,
        "name": name,
      },
    });
    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
