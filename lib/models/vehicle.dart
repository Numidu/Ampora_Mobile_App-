class Vehicle {
  final String vehicleId;
  final String model;
  final double batteryCapacity;
  final double efficiency;
  final String connectorType;

  Vehicle(
      {required this.vehicleId,
      required this.model,
      required this.batteryCapacity,
      required this.efficiency,
      required this.connectorType});
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'],
      model: json['model'],
      batteryCapacity: json['batteryCapacityKwh'].toDouble(),
      efficiency: json['efficiencyKmPerKwh'].toDouble(),
      connectorType: json['connectorType'],
    );
  }
}
