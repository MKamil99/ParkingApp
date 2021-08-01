import 'package:parking_app/pages/home/database_connection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/widgets/custom_map_in_home.dart';
import 'package:parking_app/widgets/marker_provider.dart';
import 'package:parking_app/widgets/search_dialog.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data:
  final DatabaseConnection db = DatabaseConnection();
  late GoogleMapController gmController;
  late CameraPosition currentCameraPosition;

  // Setup custom marker and database while initializing the widget:
  @override
  initState() {
    super.initState();
    db.setupCustomMarker();
    db.initDatabase(context, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: showSearchDialog,
          ),
        ],
      ),
      body: MarkerProvider(
        child: CustomMapInHome(
          setCurrentCameraPosition: setCurrentCameraPosition,
          setGoogleMapController: setGoogleMapController,
          changeCameraPosition: changeCameraPosition,
        ),
        markers: db.markers,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        onPressed: () {
          Navigator.pushNamed(context, '/add', arguments: {
            'cameraPosition': currentCameraPosition,
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Move Google Maps camera to certain position (with animation):
  void changeCameraPosition(double latitude, double longitude) {
    gmController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15)),
    );
  }

  // Setters:
  void setCurrentCameraPosition(CameraPosition position) => currentCameraPosition = position;
  void setGoogleMapController(GoogleMapController controller) => gmController = controller;

  // Show dialog with list of all locations and search bar:
  void showSearchDialog() {
    showDialog(context: context, builder: (_) {
      return SearchDialog(
          locations: db.locations,
          changeCameraPosition: changeCameraPosition
      );
    });
  }
}
