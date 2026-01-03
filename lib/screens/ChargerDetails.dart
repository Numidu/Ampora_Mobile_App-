import 'package:electric_app/main.dart';
import 'package:electric_app/models/chargersession.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/booking_service.dart';
import 'package:electric_app/service/chargersession_service.dart';
import 'package:electric_app/widget/Logo_lorder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChargerDetailsScreen extends StatefulWidget {
  const ChargerDetailsScreen({super.key});

  @override
  State<ChargerDetailsScreen> createState() => _ChargerDetailsScreenState();
}

class _ChargerDetailsScreenState extends State<ChargerDetailsScreen> {
  late String chargerId;
  late String? userId;
  final ChargerSessionService service = ChargerSessionService();
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chargerId = ModalRoute.of(context)!.settings.arguments as String;
    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
  }

  Future<void> check() async {
    if (selectedDate == null || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select date & time")),
      );
      return;
    }

    String date =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    String start =
        "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00";

    String end =
        "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00";

    try {
      bool available = await BookingService().checkAvailability({
        "userId": userId,
        "chargerId": chargerId,
        "date": date,
        "startTime": start,
        "endTime": end,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(available ? "Slot is AVAILABLE ✅" : "Slot already BOOKED ❌"),
          backgroundColor: available ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: const Color(0xFF009daa).withOpacity(0.25),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF009daa),
            size: 20,
          ),
        ),
        title: const Text(
          "Charger Details",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A1F2E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _bookingField(
                    context,
                    icon: Icons.calendar_today,
                    label: "Select Date",
                    value: selectedDate,
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        initialDate: DateTime.now(),
                      );
                      if (d != null) setState(() => selectedDate = d);
                    },
                  ),
                  const SizedBox(height: 16),
                  _bookingField(
                    context,
                    icon: Icons.access_time,
                    label: "Start Time",
                    value: startTime,
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) setState(() => startTime = t);
                    },
                  ),
                  const SizedBox(height: 16),
                  _bookingField(
                    context,
                    icon: Icons.timelapse,
                    label: "End Time",
                    value: endTime,
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) setState(() => endTime = t);
                    },
                  ),
                  ElevatedButton(onPressed: check, child: Text("Click"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _bookingField(BuildContext context,
    {required IconData icon,
    required String label,
    required dynamic value,
    required VoidCallback onTap}) {
  String text = "Tap to select";

  if (value is DateTime) {
    text =
        "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
  } else if (value is TimeOfDay) {
    text = value.format(context);
  }

  final bool dark = Theme.of(context).brightness == Brightness.dark;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF252D3C) : const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00C896)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(text,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
