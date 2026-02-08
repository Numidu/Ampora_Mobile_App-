import 'dart:ui';

import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final dynamic booking;

  const BookingCard({super.key, required this.booking});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "CONFIRMED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      case "PENDING":
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = booking.status ?? "PENDING";
    final start = booking.startTime ?? "--:--";
    final end = booking.endTime ?? "--:--";
    final amount = booking.amount ?? 0;
    final charger = booking.chargerType ?? "N/A";
    final dateText = booking.date ?? "Date not specified";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header row (charger + status)
            Row(
              children: [
                const Icon(Icons.ev_station, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  charger,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔹 Time
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text("$start  →  $end"),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(dateText),
              ],
            ),

            const SizedBox(height: 10),

            // 🔹 Amount
            Row(
              children: [
                const Icon(Icons.payments, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "LKR ${amount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
