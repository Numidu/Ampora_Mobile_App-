import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final double energy;
  final double cost;

  const SummaryPage({
    super.key,
    required this.energy,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charging Summary"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _summaryRow("Energy Used", "${energy.toStringAsFixed(2)} kWh"),
              const SizedBox(height: 16),
              _summaryRow("Total Power", "${cost.toStringAsFixed(2)} kW"),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("DONE"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
