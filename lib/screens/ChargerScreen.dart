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
      appBar: AppBar(title: Text(stationName)),
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
              );
            },
          );
        },
      ),
    );
  }
}
