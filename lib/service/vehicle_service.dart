import 'dart:convert';
import 'package:electric_app/models/vehicle.dart';
import 'package:http/http.dart' as http;

class VehicleService {
  Future<bool> registerVehicle(Map<String, dynamic> vehicleData) async {
    const String apiUrl = "http://34.14.149.31:8083/api/vehicles";
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicleData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Vehicle>> fetchVehicles(String userId) async {
    final String apiUrl = "http://34.14.149.31:8083/api/vehicles/user/$userId";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> vehiclesJson = jsonDecode(response.body);
      return vehiclesJson.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }
}
