import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:electric_app/models/chargersession.dart';

class ChargerSessionService {
  static const String baseUrl = "http://13.211.243.202:8083/api/chargersession";

  Future<List<ChargerSession>> getAllSessions() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => ChargerSession.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load sessions");
    }
  }

  List<ChargerSession> filterSessionsByCharger(
    List<ChargerSession> allSessions,
    String chargerId,
  ) {
    return allSessions.where((s) => s.chargerId == chargerId).toList();
  }

  bool isChargerFree(List<ChargerSession> sessions) {
    return !sessions.any(
      (s) => s.sessionStatus == "ONGOING",
    );
  }
}
