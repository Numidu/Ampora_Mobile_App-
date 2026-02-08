import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bookingscreen extends StatefulWidget {
  const Bookingscreen({super.key});

  @override
  State<Bookingscreen> createState() => _BookingscreenState();
}

class _BookingscreenState extends State<Bookingscreen> {
  String? userId;
  final BookingService _bookingService = BookingService();
  List bookings = [];
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;

    if (userId != null) {
      bookings = await _bookingService.getUserBookings(userId!);
      print("User Bookings: $bookings");
    } else {
      print("User ID is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Screen'),
      ),
      body: FutureBuilder(
          future: _bookingService.getUserBookings(userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return const Center(child: Text('No bookings found.'));
            } else {
              final bookings = snapshot.data as List;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return ListTile(
                    title: Text('Booking ID: ${booking.id}'),
                    subtitle: Text(
                        'Station: ${booking.stationName}\nDate: ${booking.date}\nTime: ${booking.timeSlot}'),
                  );
                },
              );
            }
          }),
    );
  }
}
