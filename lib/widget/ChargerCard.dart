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
    late Color statusColor;
    late String statusText;
    late IconData statusIcon;

    switch (status) {
      case ChargerStatus.AVAILABLE:
        statusColor = Colors.green;
        statusText = "AVAILABLE";
        statusIcon = Icons.flash_on;

        break;

      case ChargerStatus.UNAVAILABLE:
        statusColor = Colors.red;
        statusText = "BUSY";
        statusIcon = Icons.block;
        break;

      case ChargerStatus.MAINTENANCE:
        statusColor = Colors.orange;
        statusText = "OFFLINE";
        statusIcon = Icons.build;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          // Left color indicator
          Container(
            width: 6,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$power kW",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          InkWell(
            onTap: () {
              if (status == ChargerStatus.AVAILABLE) {
                Navigator.pushNamed(context, "screen/ChargerDetails",
                    arguments: id);
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, size: 16, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
