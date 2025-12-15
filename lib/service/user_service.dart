import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String apiUrl = "http://10.0.2.2:8083/api/auth/register";

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

  Future<void> loginUser(String email, String password) async {
    final response = await http.get(
      Uri.parse('http://172.20.10.4:8083/api/user'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
    } else {}
  }
}
