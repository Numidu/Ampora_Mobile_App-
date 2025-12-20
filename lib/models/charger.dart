enum ChargerStatus { AVAILABLE, UNAVAILABLE, MAINTENANCE }

class Charger {
  final String chargerID;
  final String type;
  final double powerKw;
  final ChargerStatus status;
  final String stationName;

  Charger({
    required this.chargerID,
    required this.type,
    required this.powerKw,
    required this.status,
    required this.stationName,
  });

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(
      chargerID: json['chargerID'],
      type: json['type'],
      powerKw: (json['powerKw'] as num).toDouble(),
      status: _parseStatus(json['status']),
      stationName: json['stationName'],
    );
  }

  static ChargerStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return ChargerStatus.AVAILABLE;
      case 'UNAVAILABLE':
        return ChargerStatus.UNAVAILABLE;
      default:
        return ChargerStatus.MAINTENANCE;
    }
  }
}
