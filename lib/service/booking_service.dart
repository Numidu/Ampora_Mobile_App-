import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:electric_app/models/booking.dart';

class BookingService {
  Future<bool> checkAvailability(Map<String, dynamic> data) async {
    print(data);
    const String apiurl = "http://10.0.2.2:8083/api/bookings/availability";

    final response = await http.post(
      Uri.parse(apiurl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['available'] == true;
    } else {
      throw Exception("Failed to check availability: ${response.body}");
    }
  }
}
