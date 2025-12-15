import 'package:flutter/material.dart';
import '../models/station.dart';

class AppProvider extends ChangeNotifier {
// Mock user profile
  String userName = 'Nimal Perera';
  String userEmail = 'nimal@example.com';
  String vehicle = 'Nissan Leaf';
  int batteryPercent = 65;

// Mock stations
  final List<Station> _stations = [
    Station(
      id: 's1',
      name: 'Colombo EV Center',
      lat: 6.9271,
      lng: 79.8612,
      availablesSlots: 2,
      pricePerKwh: 30.0,
      address: 'Fort, Colombo',
    ),
    Station(
      id: 's2',
      name: 'Galle Road Charge Hub',
      lat: 6.9000,
      lng: 79.8610,
      availablesSlots: 4,
      pricePerKwh: 28.5,
      address: 'Galle Road',
    ),
    Station(
      id: 's3',
      name: 'Kandy Green Station',
      lat: 7.2906,
      lng: 80.6337,
      availablesSlots: 1,
      pricePerKwh: 32.0,
      address: 'Kandy City',
    ),
  ];

  List<Station> get stations => List.unmodifiable(_stations);

  Station? getStationById(String id) {
    return _stations.firstWhere((s) => s.id == id, orElse: () => _stations[0]);
  }

  void bookSlot(String stationId) {
    final station = _stations.firstWhere((s) => s.id == stationId);
    if (station.availablesSlots > 0) {
      final index = _stations.indexOf(station);
      _stations[index] = Station(
        id: station.id,
        name: station.name,
        lat: station.lat,
        lng: station.lng,
        availablesSlots: station.availablesSlots - 1,
        pricePerKwh: station.pricePerKwh,
        address: station.address,
      );
    }
  }
}
