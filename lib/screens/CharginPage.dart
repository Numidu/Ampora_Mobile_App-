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
      if (stopped) return; // 🔑 VERY IMPORTANT

      final data = jsonDecode(message);
      if (data["type"] == "LIVE") {
        setState(() {
          power = (data["power"] as num).toDouble();
          energy = (data["energy"] as num).toDouble();
        });
      }
    });
  }

  void stopCharging() {
    if (stopped) return;
    stopped = true;

    // 1️⃣ stop backend session
    widget.ws.send({"type": "SESSION_END"});

    // 2️⃣ stop listening BEFORE navigation
    sub?.cancel();

    // 3️⃣ calculate cost
    final cost = energy * 50; // example tariff

    // 4️⃣ navigate to summary (THIS WILL NOW WORK)
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
      appBar: AppBar(title: const Text("Charging")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Power: $power kW", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text(
              "Energy: ${energy.toStringAsFixed(2)} kWh",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: stopCharging,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              ),
              child: const Text("STOP"),
            ),
          ],
        ),
      ),
    );
  }
}
