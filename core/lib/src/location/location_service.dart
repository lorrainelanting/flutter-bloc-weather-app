import 'package:geolocator/geolocator.dart';
import '../error/failure.dart';
import 'coordinates.dart';

abstract class LocationService {
  Future<Coordinates> getCurrentPosition();
}

class GeolocatorLocationService implements LocationService {
  @override
  Future<Coordinates> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledFailure();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedFailure();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedFailure();
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
    return Coordinates(latitude: position.latitude, longitude: position.longitude);
  }
}
