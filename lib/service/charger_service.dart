import 'package:electric_app/models/booking.dart';
import 'package:electric_app/models/charger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChargerService {
  static const String baseUrl = "http://34.14.149.31:8083/api/charger";

  Future<List<Charger>> fetchChargers(String stationName) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      final filtered = data.where((item) {
        return item['stationName'].toString().trim().toLowerCase() ==
            stationName.trim().toLowerCase();
      }).toList();

      return filtered.map((e) => Charger.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load chargers");
    }
  }
}
