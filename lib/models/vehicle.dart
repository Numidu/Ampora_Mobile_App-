class Vehicle {
  final String vehicleId;
  final double brandId;
  final String brandName;
  final String modelName;
  final double modelId;
  final double rangeKm;
  final double variant;
  final String connectorType;
  final String plate;
  final String userId;

  Vehicle({
    required this.vehicleId,
    required this.brandId,
    required this.brandName,
    required this.modelName,
    required this.modelId,
    required this.rangeKm,
    required this.variant,
    required this.connectorType,
    required this.plate,
    required this.userId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'],
      brandId: (json['brand_id'] as num).toDouble(),
      brandName: json['brand_name'],
      modelName: json['model_name'],
      modelId: (json['model_id'] as num).toDouble(),
      rangeKm: (json['rangeKm'] as num).toDouble(),
      variant: (json['variant'] as num).toDouble(),
      connectorType: json['connectorType'],
      plate: json['plate'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'brand_id': brandId,
      'brand_name': brandName,
      'model_name': modelName,
      'model_id': modelId,
      'rangeKm': rangeKm,
      'variant': variant,
      'connectorType': connectorType,
      'plate': plate,
      'userId': userId,
    };
  }
}
