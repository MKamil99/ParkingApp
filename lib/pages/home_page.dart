// Code used in this file bases on https://www.youtube.com/watch?v=gTHKFRRSPss
// and https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6
// (it is also used in Add Parking Page's map);
// Pin icon made by Vectors Market from www.flaticon.com

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:location/location.dart' as gps;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  Set<Marker> _markers = {};
  List<Location> _locations = [];
  late GoogleMapController _controller;

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

  // Database:
  @override
  initState() {
    super.initState();
    setupCustomMarker();
    initDatabase();
  }

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
              if (location.ranking != null) {
                _contentChildren.add(SizedBox(height: 5));
                _contentChildren.add(Text("Rating: ${location.ranking}/5"));
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
    super.build(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text('Simple Parking App'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDialog(context: context, builder: (_) {
                  return AlertDialog(
                    title: Text('List of parking locations'),
                    insetPadding: EdgeInsets.all(16),
                    contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 24),
                    content: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _locations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(_locations[index].name),
                            subtitle: Text(_locations[index].description),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                // Close dialog:
                                Navigator.of(context).pop();
                                // Go to specific position:
                                changeCameraPosition(_locations[index].latitude, _locations[index].longitude);
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
                  );
                });
              },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
      ),
    );
  }


  // Locate user on map after launching the app:
  gps.Location _location = gps.Location();
  bool _locatedOnce = false;
  void _onMapCreated(GoogleMapController controller) {
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


  // Making sure that state will not be lost after changing page:
  @override
  bool get wantKeepAlive => true;
}
