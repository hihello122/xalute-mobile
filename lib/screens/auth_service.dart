//check whether use has JWT
//true
//false
//home_page.dart의 initialization에선 이 함수의 리턴에 따라서
//login_page로 이동할지 말지 정함

//input = token output = JWT
//check
//POST operation으로 서버에 대해서 token 보내서 JWT 받아오기

//api_client add JWT for every POST operation
//그외 기존 POST의 wrapper 함수


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// ======================
// AuthService
// ======================
class AuthService {
  static final _storage = FlutterSecureStorage();

  // 1. JWT 저장
  static Future<void> saveJWT(String jwt) async {
    await _storage.write(key: 'accessToken', value: jwt);
  }

  // 2. JWT 불러오기
  static Future<String?> getJWT() async {
    return await _storage.read(key: 'accessToken');
  }

  // 3. 서버로 POST → token 입력 → JWT 반환
  static Future<String?> fetchJWTFromServer(String token) async {
    final res = await http.post(
      Uri.parse('https://yourserver.com/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['accessToken']; // 서버에서 발급한 JWT
    }

    return null;
  }

  // 4. JWT 유효성 체크 (간단하게 존재 여부만)
  static Future<bool> hasJWT() async {
    final jwt = await getJWT();
    return jwt != null;
  }
}

// ======================
// ApiClient
// ======================
class ApiClient {
  final _storage = FlutterSecureStorage();

  Future<http.Response> post(String path, {dynamic body}) async {
    final jwt = await _storage.read(key: 'accessToken');

    return http.post(
      Uri.parse('https://yourserver.com$path'),
      headers: {
        "Authorization": "Bearer $jwt",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

// GET 등 다른 HTTP 메서드도 동일하게 wrapper 가능
}

// ======================
// main.dart or home_page.dart
// ======================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hasToken = await AuthService.hasJWT();

  runApp(MaterialApp(
    home: hasToken ? HomePage() : LoginPage(),
  ));
}

// ======================
// UI Placeholder
// ======================
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Home Page')));
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Login Page')));
  }
}
