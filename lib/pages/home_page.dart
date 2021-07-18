// Code used in this file bases on:
// - https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6 (user location, camera animating),
// - https://stackoverflow.com/questions/53700347/how-do-i-make-an-editable-listview-item (stateful builder used for refreshing dialog),
// - https://www.youtube.com/watch?v=gTHKFRRSPss (adding markers, custom marker),
// - https://github.com/flutter/flutter/issues/39797 (Google Maps Widget black screen issue).
// Pin icon was made by Vectors Market from www.flaticon.com.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:location/location.dart' as gps;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data:
  Set<Marker> _markers = {};
  List<Location> _locations = [];
  List<Location> _matchingLocations = [];
  late GoogleMapController _controller;
  late CameraPosition _currentCameraPosition;
  bool _isLoading = true;

  // Poland as initial camera position:
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.90, 19),
    zoom: 5.75,
  );

  // Custom marker:
  late BitmapDescriptor _marker;
  void setupCustomMarker() async {
    _marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/parking_marker.png'
    );
  }

  @override
  initState() {
    super.initState();
    setupCustomMarker();
    initDatabase();
  }

  // Database:
  void initDatabase() async {
    // Wait a second, database needs to launch:
    await Future.delayed(Duration(seconds: 1));

    // Watch all records in "Locations" table:
    final database = Provider.of<AppDatabase>(context, listen: false);
    database.watchAllLocations().listen((data) {
      // If something changed (added / deleted record), cast all records into Markers
      // and update _markers variable so they will be displayed on map:
      Set<Marker> tmp = {};
      for (Location location in data) {
        tmp.add(Marker(
          icon: _marker,
          markerId: MarkerId(location.id.toString()),
          position: LatLng(location.latitude, location.longitude),
          // Custom onTap method which displays dialog with location details:
          onTap: () {
            showDialog(context: context, builder: (_) {
              // If location's property is not null and not empty, add it to content's children,
              // so it will be displayed in dialog as Text:
              List<Widget> _contentChildren = [];
              if (location.description.length > 0) {
                _contentChildren.add(Text("Description: ${location.description}"));
                _contentChildren.add(SizedBox(height: 5));
              }
              _contentChildren.add(Text(
                "Coordinates: (${location.latitude.toStringAsFixed(5)}, "
                "${location.longitude.toStringAsFixed(5)})"));
              if (location.rating != null) {
                _contentChildren.add(SizedBox(height: 5));
                _contentChildren.add(Text("Rating: ${location.rating}/5"));
              }

              // Display dialog:
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
            });
          }
        ));
      }
      setState(() {
        _markers = tmp;
      });

      // Also, update _locations variable so they will be displayed in Search Dialog:
      _locations = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Simple Parking App'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDialog(context: context, builder: (_) {
                  _matchingLocations = _locations;
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      title: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Enter parking name...',
                        ),
                        onChanged: (str) {
                          setState(() {
                            _matchingLocations = _locations.where((element) => element.name.contains(str)).toList();
                          });
                        },
                      ),
                      insetPadding: EdgeInsets.all(16),
                      contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 0),
                      content: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _matchingLocations.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(_matchingLocations[index].name),
                              subtitle: Text(_matchingLocations[index].description),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  // Close dialog:
                                  Navigator.of(context).pop();
                                  // Go to specific position:
                                  changeCameraPosition(_matchingLocations[index].latitude, _matchingLocations[index].longitude);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            // Go back:
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  );
                });
              },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            onCameraMove: ((position) => _currentCameraPosition = position),
            onMapCreated: _onMapCreated,
          ),
          if (_isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        onPressed: () {
          Navigator.pushNamed(context, '/add', arguments: {
            'cameraPosition': _currentCameraPosition,
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Location stuff:
  gps.Location _location = gps.Location();
  bool _locatedOnce = false;
  void _onMapCreated(GoogleMapController controller) {
    // Map has been loaded:
    setState(() { _isLoading = false; });

    // Locate user on map after launching the app:
    _controller = controller;
    _location.onLocationChanged.listen((data) {
      if (_locatedOnce == false && data.latitude != null && data.longitude != null) {
        changeCameraPosition(data.latitude!, data.longitude!);
        _locatedOnce = true;
      }
    });
  }

  // Move Google Maps camera to certain position (with animation):
  void changeCameraPosition(double latitude, double longitude) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15)
      ),
    );
  }
}
