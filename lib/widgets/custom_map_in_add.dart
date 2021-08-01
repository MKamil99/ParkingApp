import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Google Map widget used in AddParkingPage - small map with pin in the center
// and initial position in the current position from previous screen:
class CustomMapInAdd extends StatefulWidget {
  // Parent's data:
  final Function setCoordinates;

  CustomMapInAdd({ required this.setCoordinates });

  @override
  _CustomMapInAddState createState() => _CustomMapInAddState();
}

class _CustomMapInAddState extends State<CustomMapInAdd> {
  // Conditions:
  bool isLoading = true;
  bool areCoordinatesInit = false;

  @override
  Widget build(BuildContext context) {
    // Navigation arguments - initial camera position is current position from previous screen:
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    CameraPosition initialPosition = data['cameraPosition'];

    // Save current position:
    if (!areCoordinatesInit) {
      widget.setCoordinates(initialPosition);
      areCoordinatesInit = true;
    }

    // Dimensions:
    const double mapHeight = 250;
    const double iconSize = 30;

    // Render map with pin... or indicator:
    return Stack(
      children: [
        Container(
          height: mapHeight,
          width: double.maxFinite,
          child: GoogleMap(
            initialCameraPosition: initialPosition,
            myLocationEnabled: true,
            onCameraMove: ((position) => widget.setCoordinates(position)),
            onMapCreated: onMapCreated,
          ),
        ),
        Container(
          height: mapHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: iconSize / 2),
              child: Image.asset('assets/parking_marker.png', height: iconSize, width: iconSize),
            ),
          ),
        ),
        if (isLoading) CustomIndicator(height: mapHeight),
      ],
    );
  }

  // Preventing black screen:
  void onMapCreated(GoogleMapController controller) {
    Timer(Duration(milliseconds: 500), () {
      setState(() { isLoading = false; });
    });
  }
}
