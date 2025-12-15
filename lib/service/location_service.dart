import 'package:geocoding/geocoding.dart';

Future<LatLngResult> getLatLngFromAddress(String address) async {
  final locations = await locationFromAddress(address);

  if (locations.isEmpty) {
    throw Exception("Location not found");
  }

  return LatLngResult(
    latitude: locations.first.latitude,
    longitude: locations.first.longitude,
  );
}

class LatLngResult {
  final double latitude;
  final double longitude;

  LatLngResult({required this.latitude, required this.longitude});
}
