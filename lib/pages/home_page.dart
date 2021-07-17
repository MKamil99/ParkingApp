// Code used in this file bases on https://www.youtube.com/watch?v=gTHKFRRSPss
// and https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6
// (it is also used in Add Parking Page's map)

// TODO: Show last-added location at the start, display ranking, add possibility to delete (or even edit) location

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

  // Poland as initial camera position:
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.90, 19),
    zoom: 5.75,
  );

  @override
  initState() {
    super.initState();
    initDatabase();
  }

  void initDatabase() async {
    await Future.delayed(Duration(seconds: 1));
    final database = Provider.of<AppDatabase>(context, listen: false);
    database.watchAllLocations().listen((data) {
      Set<Marker> tmp = {};
      for (Location location in data) {
        tmp.add(Marker(
          markerId: MarkerId(location.name),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: location.description,
          ),
        ));
      }
      setState(() {
        _markers = tmp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
      ),
    );
  }


  // Locate user on map (but only for the first time, after launching the app):
  gps.Location _location = gps.Location();
  bool _locatedOnce = false;
  void _onMapCreated(GoogleMapController controller) {
    _location.onLocationChanged.listen((data) {
      if (_locatedOnce == false && data.latitude != null && data.longitude != null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(data.latitude!, data.longitude!), zoom: 15)
          ),
        );
        _locatedOnce = true;
      }
    });
  }


  // Making sure that state will not be lost after changing page:
  @override
  bool get wantKeepAlive => true;
}
