import 'package:electric_app/models/colorThem.dart';
import 'package:flutter/material.dart';

class StationCardMap extends StatelessWidget {
  final Map<String, dynamic> station;

  const StationCardMap({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final bool isActive = station['status'] == "ACTIVE";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ⚡ Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.ev_station, color: darkGreen, size: 28),
          ),

          const SizedBox(width: 14),

          // 📍 Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station['name'] ?? "Station",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  station['address'] ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Status badge
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'screen/Charger',
                  arguments: station["name"]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? primaryGreen : Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                station['status'] ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
