import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddParkingPageData {
  // Data:
  double? latitude;
  double? longitude;
  String name = '';
  String description = '';
  int? rating;

  // Condition:
  bool canAdd() => latitude != null && longitude != null && name.isNotEmpty;

  // Setters:
  void setName(String newValue) => name = newValue;
  void setDescription(String newValue) => description = newValue;
  void setRating(int? newValue) => rating = newValue;
  void setCoordinates(CameraPosition position) {
    longitude = position.target.longitude;
    latitude = position.target.latitude;
  }
}
