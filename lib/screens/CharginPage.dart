import 'dart:async';
import 'dart:convert';
import 'package:electric_app/screens/SummeryPage.dart';
import 'package:flutter/material.dart';
import '../service/charging_ws_service.dart';

class ChargingPage extends StatefulWidget {
  final ChargingWsService ws;

  const ChargingPage({super.key, required this.ws});

  @override
  State<ChargingPage> createState() => _ChargingPageState();
}

class _ChargingPageState extends State<ChargingPage> {
  double energy = 0.0;
  double power = 0.0;

  StreamSubscription? sub;
  bool stopped = false;

  @override
  void initState() {
    super.initState();

    sub = widget.ws.stream.listen((message) {
      if (stopped) return;

      final data = jsonDecode(message);

      if (data["type"] == "LIVE") {
        setState(() {
          power = (data["power"] as num).toDouble();
          energy = (data["energy"] as num).toDouble();
        });
      }

      if (data["type"] == "SESSION_END") {
        stopCharging();
      }
    });
  }

  void stopCharging() {
    if (stopped) return;

    stopped = true;

    widget.ws.send({"type": "SESSION_END"});

    sub?.cancel();

    final cost = energy * 85;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SummaryPage(
          energy: energy,
          cost: cost,
        ),
      ),
    );
  }

  @override
  void dispose() {
    sub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charging"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bolt,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 30),
            Text(
              "Power",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              "$power kW",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Energy Used",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              "${energy.toStringAsFixed(2)} kWh",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: stopCharging,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: const Text(
                "STOP CHARGING",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
