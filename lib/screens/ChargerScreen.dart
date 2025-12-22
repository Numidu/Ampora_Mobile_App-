import 'package:electric_app/models/charger.dart';
import 'package:electric_app/service/charger_service.dart';
import 'package:electric_app/widget/ChargerCard.dart';
import 'package:flutter/material.dart';

class Chargerscreen extends StatelessWidget {
  const Chargerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String stationName =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF009daa),
                Color(0xFF2ECC71),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(22),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x55009daa),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text(
              "Chargers",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Charger>>(
        future: ChargerService().fetchChargers(stationName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chargers found"));
          }

          final chargers = snapshot.data!;

          return ListView.builder(
            itemCount: chargers.length,
            itemBuilder: (context, index) {
              final c = chargers[index];
              return ChargerCard(
                power: c.powerKw.toString(),
                type: c.type,
                status: c.status,
                id: c.chargerID,
              );
            },
          );
        },
      ),
    );
  }
}
