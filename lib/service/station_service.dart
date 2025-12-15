import 'dart:convert';
import 'package:http/http.dart' as http;

class StationService {
  static const String baseUrl = "http://10.0.2.2:8083/api/stations";

  Future<List<Map<String, dynamic>>> fetchStations() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load stations");
    }
  }
}
