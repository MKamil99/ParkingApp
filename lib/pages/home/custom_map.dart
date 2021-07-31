import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/home/custom_indicator.dart';
import 'package:parking_app/pages/home/marker_provider.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';

class CustomGoogleMap extends StatefulWidget {
  // Parent's data:
  final Function setCurrentCameraPosition;
  final Function setGoogleMapController;
  final Function changeCameraPosition;

  CustomGoogleMap({
    required this.setCurrentCameraPosition,
    required this.setGoogleMapController,
    required this.changeCameraPosition,
  });

  @override
  _CustomGoogleMapState createState() => _CustomGoogleMapState(
        setCurrentCameraPosition,
        setGoogleMapController,
        changeCameraPosition,
      );
}

class _CustomGoogleMapState extends State {
  // Parent's data:
  final Function setCurrentCameraPosition;
  final Function setGoogleMapController;
  final Function changeCameraPosition;

  _CustomGoogleMapState(
    this.setCurrentCameraPosition,
    this.setGoogleMapController,
    this.changeCameraPosition,
  );

  // Data:
  bool isLoading = true;
  static final CameraPosition initialPosition = CameraPosition(
    target: LatLng(52.90, 19), // Poland
    zoom: 5.75,
  );

  @override
  Widget build(BuildContext context) {
    // Changeable set of markers that will be displayed in the map:
    final Set<Marker> markers = MarkerProvider.of(context)!.markers;
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: initialPosition,
        markers: markers,
        myLocationEnabled: true,
        onCameraMove: ((position) => setCurrentCameraPosition(position)),
        onMapCreated: onMapCreated,
      ),
      if (isLoading) CustomIndicator(),
    ]);
  }

  // Location stuff:
  bool locatedOnce = false;
  void onMapCreated(GoogleMapController controller) {
    // Map has been loaded:
    setState(() { isLoading = false; });

    // Get location:
    Location location = Location();

    // Locate user on map after launching the app:
    setGoogleMapController(controller);
    location.onLocationChanged.listen((data) {
      if (locatedOnce == false && data.latitude != null && data.longitude != null) {
        changeCameraPosition(data.latitude!, data.longitude!);
        locatedOnce = true;
      }
    });
  }
}
