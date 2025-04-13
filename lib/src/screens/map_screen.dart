import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/spot_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(52.5200, 13.4050);
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    final spots = await SpotService.getLiveSpots();
    setState(() {
      _markers.clear();
      for (var spot in spots) {
        _markers.add(Marker(
          markerId: MarkerId(spot.id),
          position: LatLng(spot.lat, spot.lng),
          infoWindow: InfoWindow(title: "Free Spot", snippet: spot.note),
        ));
      }
    });
  }

  void _shareSpot() async {
    await SpotService.shareCurrentLocation(note: "Free spot!");
    _loadSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parkly Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shareSpot,
        child: const Icon(Icons.add_location),
      ),
    );
  }
}
