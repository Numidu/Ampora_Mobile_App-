import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/booking_service.dart';
import 'package:electric_app/service/chargersession_service.dart';
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
  bool _isChecking = false;

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
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text("Please select date and time"),
            ],
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isChecking = true);

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

      setState(() => _isChecking = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                available ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(available ? "Slot is Available ✅" : "Slot Already Booked ❌"),
            ],
          ),
          backgroundColor:
              available ? AppTheme.primaryGreen : const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      setState(() => _isChecking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text("Server error: $e")),
            ],
          ),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      appBar: AppBar(
        backgroundColor: AppTheme.background(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.text(context),
            size: 20,
          ),
        ),
        title: Text(
          "Charger Details",
          style: TextStyle(
            color: AppTheme.text(context),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.iconBg(context),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.ev_station,
                    color: AppTheme.primaryGreen,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Center(
                child: Text(
                  "Book Your Charging Slot",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text(context),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Select your preferred date and time",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Booking Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.card(context),
                  borderRadius: BorderRadius.circular(24),
                  border: isDark
                      ? Border.all(color: AppTheme.border(context), width: 1)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booking Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.text(context),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Date Field
                    _bookingField(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: "Select Date",
                      value: selectedDate,
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                          initialDate: selectedDate ?? DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppTheme.primaryGreen,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (d != null) setState(() => selectedDate = d);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Start Time Field
                    _bookingField(
                      context,
                      icon: Icons.access_time_outlined,
                      label: "Start Time",
                      value: startTime,
                      onTap: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppTheme.primaryGreen,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (t != null) setState(() => startTime = t);
                      },
                    ),

                    const SizedBox(height: 16),

                    // End Time Field
                    _bookingField(
                      context,
                      icon: Icons.timelapse_outlined,
                      label: "End Time",
                      value: endTime,
                      onTap: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: endTime ?? TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppTheme.primaryGreen,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (t != null) setState(() => endTime = t);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFBBDEFB),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF1976D2),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Check availability before booking to ensure your preferred time slot is available',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Check Availability Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : check,
                  icon: _isChecking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.search, size: 22),
                  label: Text(
                    _isChecking ? "Checking..." : "Check Availability",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bgWhite,
                    disabledBackgroundColor:
                        AppTheme.primaryGreen.withOpacity(0.5),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : check,
                  icon: Icon(Icons.abc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    disabledBackgroundColor:
                        AppTheme.primaryGreen.withOpacity(0.5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  label: Text("Book"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _bookingField(
  BuildContext context, {
  required IconData icon,
  required String label,
  required dynamic value,
  required VoidCallback onTap,
}) {
  String text = "Tap to select";

  if (value is DateTime) {
    text =
        "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
  } else if (value is TimeOfDay) {
    text = value.format(context);
  }

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.iconBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border(context),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: value != null
                  ? AppTheme.primaryGreen.withOpacity(0.15)
                  : AppTheme.border(context).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value != null
                  ? AppTheme.primaryGreen
                  : AppTheme.textSecondary(context),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: value != null
                        ? AppTheme.text(context)
                        : AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.textSecondary(context),
          ),
        ],
      ),
    ),
  );
}
