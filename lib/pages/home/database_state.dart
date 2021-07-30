import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// State with Moor stuff:
abstract class DatabaseState extends State {
  // Data:
  Set<Marker> markers = {};
  List<Location> locations = [];

  // Custom marker:
  late BitmapDescriptor marker;
  void setupCustomMarker() async {
    marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/parking_marker.png'
    );
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
              showDialog(context: context, builder: (_) {
                return PinDialog(
                    location: location,
                    database: database,
                    setState: (input) => setState(input)
                );
              });
            }
        ));
      }
      setState(() { markers = tmp; });

      // Also, update _locations variable so they will be displayed in Search Dialog:
      locations = data;
    });
  }

  // Return nothing (it will be overridden in its children):
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Custom Widget displayed when user taps a pin:
class PinDialog extends StatelessWidget {
  final Location location;
  final AppDatabase database;
  final Function setState;

  PinDialog({ required this.location, required this.database, required this.setState });

  @override
  Widget build(BuildContext context) {
    List<Widget> _contentChildren = pinData(location);

    return AlertDialog(
      title: Text(location.name),
      // Remove content's bottom padding:
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Column(
        children: _contentChildren,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
      actions: [
        TextButton(
          child: Text("Delete", style: TextStyle(color: Colors.red)),
          onPressed: () {
            // Delete location:
            setState(() { database.deleteLocation(location); });
            // Go back:
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Okay"),
          onPressed: () {
            // Go back:
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // Display proper data in pin details:
  List<Widget> pinData(Location location) {
    List<Widget> data = [];

    // Description:
    if (location.description.length > 0) {
      data.add(Text("Description: ${location.description}"));
      data.add(SizedBox(height: 5));
    }

    // Coordinates:
    data.add(Text(
        "Coordinates: (${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)})")
    );

    // Rating:
    if (location.rating != null) {
      data.add(SizedBox(height: 5));
      data.add(Text("Rating: ${location.rating}/5"));
    }

    return data;
  }
}
