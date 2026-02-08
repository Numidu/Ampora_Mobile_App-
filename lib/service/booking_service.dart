import 'dart:convert';
import 'package:electric_app/models/booking.dart';
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

  Future<bool> createBooking(Map<String, dynamic> data) async {
    const String apiurl = "http://13.211.243.202:8083/api/bookings";

    final response = await http.post(
      Uri.parse(apiurl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; // ✅ BOOKING CREATED
    } else {
      print("Booking failed: ${response.body}");
      return false;
    }
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final String apiurl =
        "http://13.211.243.202:8083/api/bookings/user/$userId";

    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load bookings: ${response.body}");
    }
  }
}
