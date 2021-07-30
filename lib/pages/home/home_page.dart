import 'package:flutter/material.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:parking_app/pages/home/database_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as gps;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends DatabaseState {
  // Data:
  List<Location> _matchingLocations = [];
  late GoogleMapController _controller;
  late CameraPosition _currentCameraPosition;
  bool _isLoading = true;

  // Poland as initial camera position:
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.90, 19),
    zoom: 5.75,
  );

  @override
  initState() {
    super.initState();
    setupCustomMarker();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Parking App'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: showSearchDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: markers,
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

  // Show dialog with list of all locations and search bar:
  void showSearchDialog() {
    showDialog(context: context, builder: (_) {
      _matchingLocations = locations;
      return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Enter parking name...',
              ),
              onChanged: (str) {
                setState(() {
                  _matchingLocations = locations.where(
                          (element) => element.name.toLowerCase().contains(str.toLowerCase())).toList();
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
  }
}
