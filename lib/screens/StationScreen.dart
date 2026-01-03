import 'package:electric_app/service/station_service.dart';
import 'package:electric_app/widget/Logo_lorder.dart';
import 'package:electric_app/widget/StationCard.dart';
import 'package:flutter/material.dart';

class Stationscreen extends StatefulWidget {
  const Stationscreen({super.key});

  @override
  State<Stationscreen> createState() => _StationscreenState();
}

class _StationscreenState extends State<Stationscreen> {
  final StationService _stationservice = StationService();
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (value) => setState(() => query = value),
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1A2332),
            ),
            decoration: InputDecoration(
              hintText: "Search stations...",
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade600,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade600,
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1A1F2E)
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _stationservice.fetchStations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LogoLoader());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  final stations = snapshot.data!
                      .where((station) =>
                          station['name']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                          station['address']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                          station['status']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .toList();
                  if (stations.isEmpty) {
                    return const Center(child: Text("No stations found"));
                  }
                  return ListView.builder(
                    itemCount: stations.length,
                    itemBuilder: (context, index) {
                      return StationCardMap(station: stations[index]);
                    },
                  );
                }))
      ],
    );
  }
}
