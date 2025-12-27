import 'dart:convert';
import 'package:electric_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class UserService {
  final String apiUrl = "http://34.14.149.31:8083/api/auth/register";

  Future<bool> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse('http://34.14.149.31:8083/api/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      print("Login failed: ${response.body}");
    }
  }

  Future<List<User>> getAllUsers(String token) async {
    final url = Uri.parse("http://34.14.149.31:8083/api/users");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RAW BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print("JSON LENGTH: ${data.length}");

      return data.map((e) {
        print("USER JSON: $e");
        return User.fromJson(e);
      }).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<User> getuserId(String? userId) async {
    final url = Uri.parse("http://34.14.149.31:8083/api/users/$userId");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception("Faild to load");
    }
  }

  String getEmailFromToken(String token) {
    final payload = Jwt.parseJwt(token);

    return payload['sub'];
  }

  User findUserByEmail(List<User> users, String email) {
    return users.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception("User not found"),
    );
  }
}
