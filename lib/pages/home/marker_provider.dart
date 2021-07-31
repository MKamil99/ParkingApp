import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MarkerProvider extends InheritedWidget {
  final Set<Marker> markers;
  MarkerProvider({
    required Widget child,
    required this.markers,
  }) : super(child: child);

  @override
  bool updateShouldNotify(MarkerProvider oldWidget) => markers != oldWidget.markers;
  static MarkerProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<MarkerProvider>();
}
