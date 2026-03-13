import 'dart:convert';
import 'package:electric_app/models/user.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/screens/CharginPage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../service/charging_ws_service.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ChargingWsService ws = ChargingWsService();
  bool scanned = false;
  String? userId;
  User? user;

  Future<void> onQrScanned(String chargerId) async {
    try {
      print("Connecting WS...");

      ws.connect();

      print("Sending QR_SESSION_START");

      ws.send({
        "type": "QR_SESSION_START",
        "userId": userId,
        "chargerId": chargerId
      });

      final message = await ws.stream.first;

      final data = jsonDecode(message);

      print("WS RESPONSE: $data");

      if (data["type"] == "QR_AUTH_OK") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChargingPage(ws: ws),
          ),
        );
      } else {
        throw Exception("Authorization failed");
      }
    } catch (e) {
      print("QR ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Charging start failed")),
      );

      scanned = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Charger QR"),
        centerTitle: true,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) return;

          final raw = capture.barcodes.first.rawValue;

          if (raw == null) return;

          print("QR RAW: $raw");

          try {
            final data = jsonDecode(raw);

            final chargerId = data["chargerId"];

            scanned = true;

            onQrScanned(chargerId);
          } catch (e) {
            print("QR PARSE ERROR");

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid QR Code")),
            );
          }
        },
      ),
    );
  }
}
