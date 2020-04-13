import 'package:flutter/material.dart';
import 'package:lta_datamall_flutter/screens/bus/bus_arrivals/utils.dart';

class BusArrivalDetails extends StatelessWidget {
  const BusArrivalDetails({
    @required this.busDetails,
  });

  final Map busDetails;

  @override
  Widget build(BuildContext context) {
    String _getBusFeature(dynamic wab) {
      return wab == 'WAB'
          ? 'Wheelchair Accessible'
          : 'Non-Wheelchair Accessible';
    }

    String _getBusLoad(dynamic load) {
      final Map<String, String> _busLoad = <String, String>{
        'SEA': 'Seats\nAvailable',
        'SDA': 'Standing\nAvailable',
        'LSD': 'Limited\nStanding',
      };

      return load == '' ? 'N/A' : _busLoad[load];
    }

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      leading: CircleAvatar(backgroundColor: Colors.transparent),
      title: Text(
          Utility().getTimeToBusStop(busDetails['estimatedArrival'] as String)),
      subtitle: Text(
        _getBusFeature(busDetails['feature']),
      ),
      trailing: Text(
        _getBusLoad(busDetails['load']),
      ),
    );
  }
}