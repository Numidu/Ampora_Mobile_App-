class brand {
  final int id;
  final String name;

  brand({
    required this.id,
    required this.name,
  });

  factory brand.fromJson(Map<String, dynamic> json) {
    return brand(
      id: (json['brand_id'] as num).toInt(),
      name: json['brand_name'],
    );
  }
}
