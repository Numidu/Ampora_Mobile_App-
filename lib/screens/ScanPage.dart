import 'dart:convert';
import 'package:electric_app/screens/CharginPage.dart';
import 'package:electric_app/service/charging_ws_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ChargingWsService ws = ChargingWsService();
  bool scanned = false;

  Future<void> onQrScanned(String uid, String stationId) async {
    ws.connect();

    // send AUTH
    ws.send({
      "type": "AUTH_REQUEST",
      "uid": uid,
    });

    // wait ONLY for first AUTH_RESPONSE
    final message = await ws.stream.first;
    final data = jsonDecode(message);

    if (data["type"] == "AUTH_RESPONSE" && data["authorized"] == true) {
      // start charging
      ws.send({
        "type": "SESSION_START",
        "stationId": stationId,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChargingPage(ws: ws),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("AUTH FAILED")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// QR SCANNER
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                if (scanned) return;
                scanned = true;

                final raw = capture.barcodes.first.rawValue ?? "";
                final data = jsonDecode(raw);

                onQrScanned(data["uid"], data["stationId"]);
              },
            ),
          ),

          /// TEST BUTTON (NO QR)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                onQrScanned(
                  "53 18 14 05", // RFID UID
                  "EV-AMP-001", // Station ID
                );
              },
              child: const Text("TEST START (NO QR)"),
            ),
          ),
        ],
      ),
    );
  }
}
