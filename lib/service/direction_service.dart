import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchTrip(double originLat, double originLng,
    double destLat, double destLng, int bufferMeters) async {
  final base = 'http://34.14.149.31:8083'; // adjust: emulator vs real device
  final url = Uri.parse(
      '$base/api/trip?originLat=$originLat&originLng=$originLng&destLat=$destLat&destLng=$destLng&bufferMeters=$bufferMeters');
  final res = await http.get(url);
  if (res.statusCode != 200)
    throw Exception('Trip request failed: ${res.body}');
  return jsonDecode(res.body) as Map<String, dynamic>;
}
