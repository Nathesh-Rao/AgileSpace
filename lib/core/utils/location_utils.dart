import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static Future<String> getAddressFromLatLng(
      {required double latitude, required double longitude}) async {
    var output = '';
    await placemarkFromCoordinates(latitude, longitude).then((placemarks) {
      output = placemarks[0].toString();
    });
    return output;
  }

  static Future<String> getAddressFromPosition(
      {required Position position}) async {
    var output = '';
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((placemarks) {
      output = placemarks[0].toString();
    });
    return output;
  }
}
