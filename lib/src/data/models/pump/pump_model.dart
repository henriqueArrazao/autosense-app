import 'package:app/src/data/enums/fuel_type_enum.dart';

class PumpModel {
  final double price;
  final bool available;
  final FuelTypeEnum fuelType;

  PumpModel({
    required this.price,
    required this.available,
    required this.fuelType,
  });

  factory PumpModel.fromJson(Map<String, dynamic> json) {
    return PumpModel(
      price: json['price'].toDouble(),
      available: json['available'],
      fuelType: FuelTypeEnum.fromString(json['fuelType']),
    );
  }

  Map<String, dynamic> toJson() => {
        'price': price,
        'available': available,
        'fuelType': fuelType.toString(),
      };
}
