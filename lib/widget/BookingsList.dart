import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/booking_service.dart';
import 'package:electric_app/widget/BookingCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsList extends StatelessWidget {
  final String query;

  const BookingsList({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final bookingService = BookingService();
    final userId = context.read<AuthProvider>().currentUser?.userId;

    if (userId == null) {
      return const Center(child: Text("Please login to view bookings"));
    }

    return FutureBuilder<List>(
      future: bookingService.getUserBookings(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No bookings found"));
        }

        // 🔎 Safe filtering (backend fields aware)
        final bookings = snapshot.data!
            .where((b) =>
                (b.chargerType ?? "")
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (b.status ?? "").toLowerCase().contains(query.toLowerCase()) ||
                (b.startTime ?? "")
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (b.endTime ?? "").toLowerCase().contains(query.toLowerCase()))
            .toList();
        print(
            "Filtered Bookings: ${bookings.length} out of ${snapshot.data!.length} for query '$query'");

        if (bookings.isEmpty) {
          return const Center(child: Text("No matching bookings"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return BookingCard(booking: bookings[index]);
          },
        );
      },
    );
  }
}
