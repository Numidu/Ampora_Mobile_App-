import 'package:electric_app/models/charger.dart';
import 'package:flutter/material.dart';

class ChargerCard extends StatelessWidget {
  final String id;
  final String power;
  final String type;
  final ChargerStatus status;

  const ChargerCard({
    super.key,
    required this.id,
    required this.power,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ default values (prevents late errors)
    Color statusColor = Colors.grey;
    String statusText = "UNKNOWN";
    IconData statusIcon = Icons.help_outline;

    switch (status) {
      case ChargerStatus.AVAILABLE:
        statusColor = Colors.greenAccent;
        statusText = "AVAILABLE";
        statusIcon = Icons.flash_on;
        break;

      case ChargerStatus.UNAVAILABLE:
        statusColor = Colors.redAccent;
        statusText = "BUSY";
        statusIcon = Icons.block;
        break;

      case ChargerStatus.MAINTENANCE:
        statusColor = Colors.orangeAccent;
        statusText = "OFFLINE";
        statusIcon = Icons.build;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: statusColor.withOpacity(0.10),
        border: Border.all(
          color: statusColor.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // ⚡ Energy bar
          Container(
            width: 6,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 16),

          // 🔋 Charger info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$power kW",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // 🟢 Status chip (logic unchanged)
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              if (status == ChargerStatus.AVAILABLE) {
                Navigator.pushNamed(
                  context,
                  "screen/ChargerDetails",
                  arguments: id,
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Not Available"),
                    content: const Text("Can't see session"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
