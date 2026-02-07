import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OysterFarmMapScreen extends StatefulWidget {
  const OysterFarmMapScreen({Key? key}) : super(key: key);

  @override
  State<OysterFarmMapScreen> createState() => _OysterFarmMapScreenState();
}

class _OysterFarmMapScreenState extends State<OysterFarmMapScreen> {
  // Oyster Farm coordinates
  static const double oysterFarmLat = 14.346233;
  static const double oysterFarmLng = 120.779424;

  // Center map near the Philippines
  late final MapController _mapController;
  late final LatLng _oysterFarmLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _oysterFarmLocation = LatLng(oysterFarmLat, oysterFarmLng);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _showOysterFarmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oyster Farm Location'),
          content: const Text('Oyster Farm Location\nCoordinates: 14.346233, 120.779424'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oyster Farm Map'),
      ),
      body: SizedBox.expand(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            // Center the map near the Philippines
            initialCenter: LatLng(12.8797, 121.7740),
            initialZoom: 6.0,
            // Allow zooming and panning/swiping
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom | InteractiveFlag.scrollWheelZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            // OpenStreetMap tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'ostrea.app',
            ),
            // Marker layer with the Oyster Farm marker
            MarkerLayer(
              markers: [
                Marker(
                  point: _oysterFarmLocation,
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: _showOysterFarmDialog,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                        const Text(
                          'Oyster Farm',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
