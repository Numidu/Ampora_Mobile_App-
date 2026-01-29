class model {
  final int id;
  final String name;
  final int brand_id;

  model({
    required this.id,
    required this.name,
    required this.brand_id,
  });

  factory model.fromJson(Map<String, dynamic> json) {
    return model(
      id: (json['model_id'] as num).toInt(),
      name: json['model_name'],
      brand_id: (json['brand_id'] as num).toInt(),
    );
  }
}
