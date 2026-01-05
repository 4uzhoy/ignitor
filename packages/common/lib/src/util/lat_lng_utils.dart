// ignore_for_file: constant_identifier_names

import 'package:latlong2/latlong.dart';

abstract class LatLngUtils {
  const LatLngUtils._();

  /// Calculate the centroid of a list of [points].
  static LatLng calculateCentroid(List<LatLng> points) {
    num latitudeSum = 0;
    num longitudeSum = 0;
    final numPoints = points.length;

    for (final point in points) {
      latitudeSum += point.latitude;
      longitudeSum += point.longitude;
    }

    return LatLng(latitudeSum / numPoints, longitudeSum / numPoints);
  }
}
