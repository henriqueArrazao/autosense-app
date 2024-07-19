import 'package:app/src/data/enums/fuel_type_enum.dart';
import 'package:app/src/data/models/pump/pump_model.dart';

class PumpEditingModel {
  final double? price;
  final bool available;
  final FuelTypeEnum? fuelType;

  PumpEditingModel({
    this.price,
    this.fuelType,
    this.available = true,
  });

  Map<String, dynamic> toJson() => {
        'price': price,
        'available': available,
        'fuelType': fuelType.toString(),
      };

  PumpEditingModel copyWith({
    double? price,
    bool? available,
    FuelTypeEnum? fuelType,
  }) {
    return PumpEditingModel(
      price: price ?? this.price,
      available: available ?? this.available,
      fuelType: fuelType ?? this.fuelType,
    );
  }

  PumpModel forceParseToPumpModel() {
    return PumpModel(
      price: price!,
      available: available,
      fuelType: fuelType!,
    );
  }
}
