import 'package:electric_app/service/station_service.dart';
import 'package:electric_app/widget/Logo_lorder.dart';
import 'package:electric_app/widget/StationCard.dart';
import 'package:flutter/material.dart';

class StationsList extends StatelessWidget {
  final String query;
  const StationsList({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final service = StationService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: service.fetchStations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: LogoLoader());
        }

        final stations = snapshot.data!
            .where((s) =>
                s['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                s['address']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: stations.length,
          itemBuilder: (context, i) {
            return StationCardMap(station: stations[i]);
          },
        );
      },
    );
  }
}
