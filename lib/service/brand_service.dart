import 'dart:convert';

import 'package:electric_app/models/brand.dart';
import 'package:http/http.dart' as http;

class BrandService {
  static const String baseUrl = "http://13.211.243.202:8083/api/brands";

  Future<List<brand>> fetchBrands() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => brand.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load brands");
    }
  }
}
