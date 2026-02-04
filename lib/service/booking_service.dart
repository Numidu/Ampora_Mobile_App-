import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingService {
  Future<bool> checkAvailability(Map<String, dynamic> data) async {
    print(data);
    const String apiurl =
        "http://13.211.243.202:8083/api/bookings/availability";

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
