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
          ),
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
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: citySearchCtrl,
                onSubmitted: searchStationsByCity,
                decoration: const InputDecoration(
                  hintText: "Search city (Colombo, Kandy...)",
                  prefixIcon: Icon(Icons.location_city),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlacePickerField(
              label: "Start",
              onSelected: (lat, lng, _) {
                startLat = lat;
                startLng = lng;
              },
            ),
            const SizedBox(height: 8),
            PlacePickerField(
              label: "Destination",
              onSelected: (lat, lng, _) {
                endLat = lat;
                endLng = lng;
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                planTrip();
              },
              child: const Text("Plan Trip"),
            ),
          ],
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
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.ev_station, color: Color(0xFF009daa)),
                const SizedBox(width: 8),
                Expanded(child: Text(station['name'] ?? "Station")),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Navigate"),
            )
          ],
        ),
      ),
    );
  }
}
