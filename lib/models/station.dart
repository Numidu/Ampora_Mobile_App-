class Station {
  final String stationId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String status;

  Station({
    required this.stationId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationId: json["stationId"],
      name: json["name"],
      address: json["address"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      status: json["status"],
    );
  }
}
