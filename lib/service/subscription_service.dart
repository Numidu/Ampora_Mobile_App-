import 'dart:convert';
import 'package:electric_app/models/subscription.dart';
import 'package:http/http.dart' as http;

class SubscriptionService {
  final String apiUrl = "http://34.14.149.31:8083/api/subscription";

  Future<bool> createSubscription(Map<String, dynamic> subscriptionData) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(subscriptionData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Subscription?> fetchSubscription(String? userId) async {
    final response = await http.get(
      Uri.parse("http://34.14.149.31:8083/api/subscription/user/${userId}"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Subscription.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      return null;
    } else {
      print('Failed to load subscription: ${response.statusCode}');
      throw Exception('Failed to load subscription');
    }
  }
}
