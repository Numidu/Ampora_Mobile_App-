import 'dart:convert';
import 'package:electric_app/models/subscription.dart';
import 'package:http/http.dart' as http;

class SubscriptionService {
  final String apiUrl = "http://172.20.10.4:8083/api/subscription";

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

  Future<Subscription?> fetchSubscription(String userId) async {
    final response = await http.get(
      Uri.parse(
          "http://10.0.2.2:8083/api/subscription/user/4df6809b-8d4c-45aa-aeab-f0e4cb3e2aba"),
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
