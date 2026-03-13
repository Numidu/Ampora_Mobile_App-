import 'dart:ui';
import 'package:electric_app/models/colorThem.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final dynamic booking;
  const BookingCard({super.key, required this.booking});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "CONFIRMED":
        return AppTheme.darkGreen;
      case "CANCELLED":
        return Colors.red.shade600;
      case "PENDING":
      default:
        return const Color(0xFFFF9500);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = booking.status ?? "PENDING";
    final start = booking.startTime ?? "--:--";
    final end = booking.endTime ?? "--:--";
    final amount = booking.amount ?? 0;
    final charger = booking.chargerType ?? "N/A";
    final dateText = booking.date != null
        ? "${booking.date.day}/${booking.date.month}/${booking.date.year}"
        : "Date not available";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppTheme.border(context),
          width: 0.5,
        ),
      ),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header row (charger + status)
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.iconBg(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.ev_station,
                    color: AppTheme.primaryGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    charger,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.text(context),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _statusColor(status).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(status),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🔹 Time
            _buildInfoRow(
              context,
              icon: Icons.access_time,
              text: "$start  →  $end",
            ),
            const SizedBox(height: 10),

            // 🔹 Date
            _buildInfoRow(
              context,
              icon: Icons.calendar_today_outlined,
              text: dateText,
            ),
            const SizedBox(height: 10),

            // 🔹 Amount
            _buildInfoRow(
              context,
              icon: Icons.account_balance_wallet_outlined,
              text: "LKR ${amount.toStringAsFixed(2)}",
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: AppTheme.textSecondary(context),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: isBold
                ? AppTheme.text(context)
                : AppTheme.textSecondary(context),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
