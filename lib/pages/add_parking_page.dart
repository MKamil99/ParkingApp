import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';

class AddParkingPage extends StatefulWidget {
  @override
  _AddParkingPageState createState() => _AddParkingPageState();
}

class _AddParkingPageState extends State<AddParkingPage> {
  // Data:
  double? _latitude;
  double? _longitude;
  String _name = '';
  String _description = '';
  int? _rating;

  // Conditions:
  bool canAdd() => _latitude != null && _longitude != null && _name.isNotEmpty;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    // Database:
    final _database = Provider.of<AppDatabase>(context);

    // Dimensions:
    double _mapHeight = MediaQuery.of(context).size.height / 3;
    double _mapWidth = MediaQuery.of(context).size.width;
    double _iconSize = 30.0;

    // Navigation arguments:
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    CameraPosition _initialPosition = data['cameraPosition'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Parking App'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight - 50,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: _mapHeight,
                    width: _mapWidth,
                    child: GoogleMap(
                      initialCameraPosition: _initialPosition,
                      myLocationEnabled: true,
                      onCameraMove: ((position) => updatePosition(position)),
                      onMapCreated: (GoogleMapController controller) {
                        // Preventing black screen:
                        Timer(Duration(milliseconds: 500), () {
                          setState(() { _isLoading = false; });
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: (_mapHeight) / 2 - _iconSize,
                    left: (_mapWidth - _iconSize) / 2,
                    child: Image.asset('assets/parking_marker.png', height: _iconSize, width: _iconSize),
                  ),
                  if (_isLoading)
                    Container(
                      height: _mapHeight,
                      width: _mapWidth,
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: "Name"),
                        onChanged: (str) { setState(() { _name = str; }); },
                        maxLength: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Description"),
                        onChanged: (str) { setState(() { _description = str; }); },
                        maxLength: 50,
                        maxLines: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rating: "),
                          RatingBar.builder(
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              _rating = rating.toInt();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                // Null makes the button disable:
                onPressed: canAdd() ? () => addLocation(context, _database) : null,
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Adding parking location to database:
  void addLocation(BuildContext context, AppDatabase database) {
    // Update database:
    database.insertLocation(
        Location(
            name: _name,
            latitude: _latitude!,
            longitude: _longitude!,
            description: _description,
            rating: _rating
        )
    );

    // Go back to Home Page:
    Navigator.of(context).pop();
  }

  // Updating _latitude and _longitude variables after moving camera:
  void updatePosition(CameraPosition position) {
    _longitude = position.target.longitude;
    _latitude = position.target.latitude;
  }
}
