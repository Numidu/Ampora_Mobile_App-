import 'package:electric_app/models/chargersession.dart';
import 'package:electric_app/service/chargersession_service.dart';
import 'package:flutter/material.dart';

class ChargerDetailsScreen extends StatefulWidget {
  const ChargerDetailsScreen({super.key});

  @override
  State<ChargerDetailsScreen> createState() => _ChargerDetailsScreenState();
}

class _ChargerDetailsScreenState extends State<ChargerDetailsScreen> {
  late String chargerId;
  final ChargerSessionService service = ChargerSessionService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chargerId = ModalRoute.of(context)!.settings.arguments as String;
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
      body: FutureBuilder<List<ChargerSession>>(
        future: service.getAllSessions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allSessions = snapshot.data!;
          final chargerSessions =
              service.filterSessionsByCharger(allSessions, chargerId);

          final free = service.isChargerFree(chargerSessions);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  free ? "🟢 Free Slot Available" : "🔴 Charger Busy",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: free
                      ? () {
                          // booking logic
                        }
                      : null,
                  child: const Text("Book Slot"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
