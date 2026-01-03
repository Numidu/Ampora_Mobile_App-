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
    Color statusColor = Colors.grey;
    String statusText = "UNKNOWN";
    IconData statusIcon = Icons.help_outline;

    switch (status) {
      case ChargerStatus.AVAILABLE:
        statusColor = const Color(0xFF2ECC71);
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
        statusText = "MAINTENANCE";
        statusIcon = Icons.build;
        break;
    }

    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        if (status == ChargerStatus.AVAILABLE) {
          Navigator.pushNamed(context, "screen/ChargerDetails", arguments: id);
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Not Available"),
              content: const Text("Can't see session"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: dark ? const Color(0xFF1A1F2E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: dark
                  ? Colors.black.withOpacity(0.6)
                  : statusColor.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // glowing bar
            Container(
              width: 6,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor,
                    statusColor.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16),

            // ⚡ Power circle
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withOpacity(0.5),
              ),
              child: const Icon(Icons.ev_station, color: Colors.white),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$power kW",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : const Color(0xFF1A2332),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 13,
                      color: dark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Status pill
            Container(
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
          ],
        ),
      ),
    );
  }
}
