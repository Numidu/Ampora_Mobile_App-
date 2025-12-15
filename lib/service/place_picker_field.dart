import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class PlacePickerField extends StatefulWidget {
  final String label;
  final void Function(double lat, double lng, String name) onSelected;

  const PlacePickerField({
    super.key,
    required this.label,
    required this.onSelected,
  });

  @override
  State<PlacePickerField> createState() => _PlacePickerFieldState();
}

class _PlacePickerFieldState extends State<PlacePickerField> {
  final _controller = TextEditingController();
  final places =
      FlutterGooglePlacesSdk("AIzaSyDTJZLVjkqrfqg8_G1ufEWrWSWkwbczqdw");

  List<AutocompletePrediction> predictions = [];

  Future<void> search(String input) async {
    if (input.isEmpty) {
      setState(() => predictions = []);
      return;
    }

    final res = await places.findAutocompletePredictions(
      input,
      countries: ["LK"], // Sri Lanka only
    );

    setState(() => predictions = res.predictions);
  }

  Future<void> selectPlace(AutocompletePrediction p) async {
    final details = await places.fetchPlace(
      p.placeId,
      fields: [PlaceField.Location],
    );

    final loc = details.place?.latLng;
    if (loc != null) {
      widget.onSelected(loc.lat, loc.lng, p.primaryText);
      _controller.text = p.primaryText;
      setState(() => predictions = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
          ),
          onChanged: search,
        ),
        if (predictions.isNotEmpty)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (c, i) {
                final p = predictions[i];
                return ListTile(
                  title: Text(p.primaryText),
                  subtitle: Text(p.secondaryText),
                  onTap: () => selectPlace(p),
                );
              },
            ),
          )
      ],
    );
  }
}
