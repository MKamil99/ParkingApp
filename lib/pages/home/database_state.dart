import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/home/pin_dialog.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// State with Moor stuff:
abstract class DatabaseState extends State {
  // Data:
  Set<Marker> markers = {};
  List<Location> locations = [];

  // Custom marker:
  late BitmapDescriptor marker;
  void setupCustomMarker() async {
    marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/parking_marker.png');
  }

  // Connection with database:
  void initDatabase() async {
    // Wait a second, database needs to launch:
    await Future.delayed(Duration(seconds: 1));

    // Watch all records in "Locations" table and cast them to Markers:
    final database = Provider.of<AppDatabase>(context, listen: false);
    database.watchAllLocations().listen((data) {
      Set<Marker> tmp = {};
      for (Location location in data) {
        tmp.add(Marker(
            icon: marker,
            markerId: MarkerId(location.id.toString()),
            position: LatLng(location.latitude, location.longitude),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return PinDialog(
                        location: location,
                        database: database,
                        setState: (input) => setState(input),
                    );
                  });
            }));
      }
      setState(() { markers = tmp; });

      // Also, update _locations variable so they will be displayed in Search Dialog:
      locations = data;
    });
  }

  // Setup custom marker and database while initializing the widget:
  @override
  initState() {
    super.initState();
    setupCustomMarker();
    initDatabase();
  }

  // Return nothing (it will be overridden in its children):
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
