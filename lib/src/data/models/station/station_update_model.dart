import 'package:app/src/data/models/pump/pump_model.dart';

class StationUpdateModel {
  final int id;
  final String name;
  final List<PumpModel> pumps;

  StationUpdateModel({
    required this.id,
    required this.name,
    required this.pumps,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pumps': pumps.map((pump) => pump.toJson()).toList(),
    };
  }
}
