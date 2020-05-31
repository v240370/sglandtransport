import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:lta_datamall_flutter/models/bus_stops/bus_stop_model.dart';
import 'package:lta_datamall_flutter/models/user_location.dart';

class NearbyBusStopsProvider with ChangeNotifier {
  NearbyBusStopsProvider({@required this.allBusStops});

  final List<BusStopModel> allBusStops;

  List<BusStopModel> getNearbyBusStops(UserLocation userLocation) {
    final nearbyBusStops = <BusStopModel>[];
    final distance = Distance();
    for (final busStop in allBusStops) {
      final distanceInMeters = distance(
        LatLng(userLocation.latitude, userLocation.longitude),
        LatLng(busStop.latitude, busStop.longitude),
      );

      if (distanceInMeters <= 500) {
        final deepCopyBusStop = BusStopModel.fromJson(busStop.toJson());
        deepCopyBusStop.distanceInMeters = distanceInMeters.round();
        nearbyBusStops.add(deepCopyBusStop);
      }
    }
    nearbyBusStops.sort((BusStopModel a, BusStopModel b) =>
        a.distanceInMeters.compareTo(b.distanceInMeters));

    return nearbyBusStops;
  }
}
