import '../pump/pump_model.dart';

class StationDetailedModel {
  final int id;
  final String name;
  final String address;
  final String city;
  final List<PumpModel> pumps;

  StationDetailedModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.pumps,
  });

  factory StationDetailedModel.fromJson(Map<String, dynamic> json) {
    final pumps = (json['pumps'] as List)
        .map((pumpJson) => PumpModel.fromJson(pumpJson))
        .toList();

    return StationDetailedModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      pumps: pumps,
    );
  }
}
