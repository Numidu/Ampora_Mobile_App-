class Station {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final int availablesSlots;
  final double pricePerKwh;
  final String address;
  Station({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.availablesSlots,
    required this.pricePerKwh,
    required this.address,
  });
}
