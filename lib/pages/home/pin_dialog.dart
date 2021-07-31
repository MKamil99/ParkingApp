import 'package:parking_app/db/moor_database.dart';
import 'package:flutter/material.dart';

// Custom Widget displayed when user taps a pin:
class PinDialog extends StatelessWidget {
  // Parent's data:
  final Location location;
  final AppDatabase database;
  final Function setState;

  PinDialog({
    required this.location,
    required this.database,
    required this.setState
  });

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
        "Coordinates: (${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)})"));

    // Rating:
    if (location.rating != null) {
      data.add(SizedBox(height: 5));
      data.add(Text("Rating: ${location.rating}/5"));
    }

    return data;
  }
}
