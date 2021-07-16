import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _locations = {};

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(50.36, 18.93),
    zoom: 9,
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
        _locations = tmp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _locations,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  // Making sure that state will not be lost after changing page:
  @override
  bool get wantKeepAlive => true;
}
