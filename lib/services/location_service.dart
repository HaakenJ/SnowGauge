import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  Position? currentPosition;

  // Function to get the current location data
  Stream<Position> getLocation() async {
    LocationPermission permission = await geolocator.requestPermission();



    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
        setState(() {
          currentPosition = position;
        });
      });
    }
  }
}