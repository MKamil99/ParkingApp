import 'package:parking_app/pages/add_parking/custom_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CustomMapInAdd extends StatefulWidget {
  // Parent's data:
  final double mapHeight;
  final double mapWidth;
  final Function setCoordinates;

  CustomMapInAdd({
    required this.mapHeight,
    required this.mapWidth,
    required this.setCoordinates,
  });

  @override
  _CustomMapInAddState createState() => _CustomMapInAddState();
}

class _CustomMapInAddState extends State<CustomMapInAdd> {
  // Data:
  bool isLoading = true;
  double iconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    // Navigation arguments:
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    CameraPosition initialPosition = data['cameraPosition'];

    return Stack(
      children: [
        Container(
          height: widget.mapHeight,
          width: widget.mapWidth,
          child: GoogleMap(
            initialCameraPosition: initialPosition,
            myLocationEnabled: true,
            onCameraMove: ((position) => widget.setCoordinates(position)),
            onMapCreated: onMapCreated,
          ),
        ),
        Positioned(
          top: (widget.mapHeight) / 2 - iconSize,
          left: (widget.mapWidth - iconSize) / 2,
          child: Image.asset('assets/parking_marker.png', height: iconSize, width: iconSize),
        ),
        if (isLoading) CustomIndicator(height: widget.mapHeight),
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
