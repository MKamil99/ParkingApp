import 'package:flutter/material.dart';
import 'package:parking_app/db/moor_database.dart';

// Single row in Search Dialog (name, description and arrow-button):
class LocationRow extends StatelessWidget {
  // Parent's data:
  final Location currentLocation;
  final Function changeCameraPosition;

  LocationRow({
    required this.currentLocation,
    required this.changeCameraPosition
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(currentLocation.name),
      subtitle: Text(currentLocation.description),
      trailing: IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: () {
          // Close dialog:
          Navigator.of(context).pop();
          // Go to specific position:
          changeCameraPosition(currentLocation.latitude, currentLocation.longitude);
        },
      ),
    );
  }
}
