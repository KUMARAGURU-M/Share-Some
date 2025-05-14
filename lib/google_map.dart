import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myCurrentLocation = const LatLng(11.9416, 79.8083);

  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,

        markers: markers,
        // Setting the controller when the map is created
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        // Initial camera position of the map
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 14,
        ),
      ),
    );
  }
}