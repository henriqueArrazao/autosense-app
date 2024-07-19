import 'package:app/src/data/models/pump/pump_model.dart';

class StationCreateModel {
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final List<PumpModel> pumps;

  StationCreateModel({
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.pumps,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'pumps': pumps.map((pump) => pump.toJson()).toList(),
    };
  }
}
