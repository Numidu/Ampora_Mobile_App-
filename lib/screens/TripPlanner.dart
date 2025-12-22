import 'package:electric_app/service/Station_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

import 'package:electric_app/service/direction_service.dart';
import 'package:electric_app/service/place_picker_field.dart';

class TripPlanner extends StatefulWidget {
  const TripPlanner({super.key});

  @override
  State<TripPlanner> createState() => _TripPlannerState();
}

class _TripPlannerState extends State<TripPlanner> {
  gmap.GoogleMapController? mapController;

  double? startLat, startLng;
  double? endLat, endLng;

  Set<gmap.Marker> markers = {};
  Set<gmap.Polyline> polylines = {};

  bool loading = false;
  gmap.BitmapDescriptor? stationIcon;

  Map<String, dynamic>? selectedStation;
  final TextEditingController citySearchCtrl = TextEditingController();

  final places = FlutterGooglePlacesSdk("YOUR_GOOGLE_API_KEY");

  // ---------------- ICON LOAD ----------------
  @override
  void initState() {
    super.initState();
    _loadStationIcon();
  }

  Future<void> _init() async {
    await _loadStationIcon();
  }

  Future<void> _loadStationIcon() async {
    stationIcon = await gmap.BitmapDescriptor.asset(
      const ImageConfiguration(
        size: Size(64, 64), //
        devicePixelRatio: 2.5,
      ),
      'images/chargin_station.png',
    );
    print("ICON LOADED SUCCESSFULLY");
  }

  Future<gmap.LatLng?> getCityLatLng(String city) async {
    final places =
        FlutterGooglePlacesSdk("AIzaSyDTJZLVjkqrfqg8_G1ufEWrWSWkwbczqdw");

    final res = await places.findAutocompletePredictions(
      city,
      countries: ["LK"],
    );

    if (res.predictions.isEmpty) return null;

    final details = await places.fetchPlace(
      res.predictions.first.placeId,
      fields: [PlaceField.Location],
    );

    final loc = details.place?.latLng;
    if (loc == null) return null;

    return gmap.LatLng(loc.lat, loc.lng);
  }

  // ---------------- CITY → LATLNG ----------------
  Future<void> searchStationsByCity(String city) async {
    print("call serchbar");
    final cityLatLng = await getCityLatLng(city);
    if (cityLatLng == null) return;

    markers.clear();
    polylines.clear();

    final stations = await StationService().fetchStations();
    print("this is station $stationIcon");
    for (var s in stations) {
      markers.add(
        gmap.Marker(
          markerId: gmap.MarkerId(s['stationId']),
          position: gmap.LatLng(s['latitude'], s['longitude']),
          infoWindow: gmap.InfoWindow(
            title: s['name'],
            snippet: s['address'],
          ),
          icon: stationIcon ?? gmap.BitmapDescriptor.defaultMarker,
          onTap: () {
            setState(() => selectedStation = s);
          },
        ),
      );
    }

    setState(() {});

    mapController?.animateCamera(
      gmap.CameraUpdate.newLatLngZoom(cityLatLng, 12),
    );
  }

  // ---------------- PLAN ROUTE ----------------
  Future<void> planTrip() async {
    if (startLat == null || endLat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select start and destination")),
      );
      return;
    }

    setState(() {
      loading = true;
      markers.clear();
      polylines.clear();
    });

    try {
      final trip = await fetchTrip(
        startLat!,
        startLng!,
        endLat!,
        endLng!,
        5000,
      );

      final decoded = PolylinePoints.decodePolyline(
        trip['route']['overviewPolyline'],
      );

      final points =
          decoded.map((p) => gmap.LatLng(p.latitude, p.longitude)).toList();

      polylines.add(
        gmap.Polyline(
          polylineId: const gmap.PolylineId("route"),
          points: points,
          width: 6,
          color: Colors.blue,
        ),
      );

      final stations = trip['stations'] ?? [];

      for (var s in stations) {
        markers.add(
          gmap.Marker(
              markerId: gmap.MarkerId(s['stationId']),
              position: gmap.LatLng(s['latitude'], s['longitude']),
              infoWindow: gmap.InfoWindow(title: s['name']),
              icon: stationIcon ?? gmap.BitmapDescriptor.defaultMarker,
              onTap: () {
                setState(() {
                  selectedStation = s;
                });
              }),
        );
      }

      setState(() {});

      mapController?.animateCamera(
        gmap.CameraUpdate.newLatLngBounds(_bounds(points), 80),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  gmap.LatLngBounds _bounds(List<gmap.LatLng> list) {
    double minLat = list.first.latitude;
    double maxLat = list.first.latitude;
    double minLng = list.first.longitude;
    double maxLng = list.first.longitude;

    for (var p in list) {
      minLat = p.latitude < minLat ? p.latitude : minLat;
      maxLat = p.latitude > maxLat ? p.latitude : maxLat;
      minLng = p.longitude < minLng ? p.longitude : minLng;
      maxLng = p.longitude > maxLng ? p.longitude : maxLng;
    }

    return gmap.LatLngBounds(
      southwest: gmap.LatLng(minLat, minLng),
      northeast: gmap.LatLng(maxLat, maxLng),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          gmap.GoogleMap(
            initialCameraPosition: const gmap.CameraPosition(
              target: gmap.LatLng(7.8731, 80.7718),
              zoom: 7,
            ),
            onMapCreated: (c) => mapController = c,
            markers: markers,
            polylines: polylines,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),

          // 🔍 CITY SEARCH
          Positioned(
            top: 35,
            left: 16,
            right: 16,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: TextField(
                controller: citySearchCtrl,
                onSubmitted: searchStationsByCity,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: "Search city (Colombo, Kandy...)",
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                  border: InputBorder.none,
                  filled: true,
                ),
              ),
            ),
          ),

          // 🚗 ROUTE BUTTON
          Positioned(
            right: 16,
            bottom: 120,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => _openRoutePopup(context),
              child: const Icon(Icons.route, color: Colors.black),
            ),
          ),

          // 📍 STATION CARD
          if (selectedStation != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 20,
              child: StationCard(
                station: selectedStation!,
                onClose: () => setState(() => selectedStation = null),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- ROUTE POPUP ----------------
  void _openRoutePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 🔥 for rounded container
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              // 🔹 Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Plan Your Route",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    PlacePickerField(
                      label: "Start Location",
                      onSelected: (lat, lng, _) {
                        startLat = lat;
                        startLng = lng;
                      },
                    ),
                    const SizedBox(height: 12),
                    PlacePickerField(
                      label: "Destination",
                      onSelected: (lat, lng, _) {
                        endLat = lat;
                        endLng = lng;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      planTrip();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF009DAA), // your app color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Plan Trip",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- STATION CARD ----------------
class StationCard extends StatelessWidget {
  final Map<String, dynamic> station;
  final VoidCallback onClose;

  const StationCard({
    super.key,
    required this.station,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon badge
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF009daa).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.ev_station,
                    color: Color(0xFF009daa),
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                // Station name
                Expanded(
                  child: Text(
                    station['name'] ?? "Station",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Close button
                InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'screen/Charger',
                    arguments: station['name'],
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text(
                  "Find Chargers",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009daa),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
