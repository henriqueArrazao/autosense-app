import 'package:app/src/data/enums/fuel_type_enum.dart';
import 'package:app/src/data/models/pump/pump_editing_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PumpForm extends StatelessWidget {
  final void Function(PumpEditingModel pump) onChange;
  final PumpEditingModel pump;
  final VoidCallback onRemove;
  final bool isStationBeingCreated;

  const PumpForm({
    Key? key,
    required this.isStationBeingCreated,
    required this.pump,
    required this.onChange,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<FuelTypeEnum>(
              value: pump.fuelType,
              decoration: const InputDecoration(
                labelText: 'Fuel Type',
                border: OutlineInputBorder(),
              ),
              items: FuelTypeEnum.values.map((FuelTypeEnum fuelType) {
                return DropdownMenuItem<FuelTypeEnum>(
                  value: fuelType,
                  child: Text(fuelType.toString().split('.').last),
                );
              }).toList(),
              onChanged: isStationBeingCreated
                  ? (FuelTypeEnum? newValue) {
                      onChange(pump.copyWith(fuelType: newValue));
                    }
                  : null,
              validator: (value) {
                if (value == null) {
                  return 'Please select a fuel type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            SwitchListTile(
              title: const Text('Available'),
              value: pump.available,
              onChanged: isStationBeingCreated
                  ? (bool newValue) {
                      onChange(pump.copyWith(available: newValue));
                    }
                  : null,
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              initialValue: pump.price?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (value) {
                onChange(pump.copyWith(price: double.tryParse(value) ?? 0.0));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                final price = double.tryParse(value);
                if (price == null) {
                  return 'Please enter a valid number';
                }
                if (price <= 0.0) {
                  return 'No free pump buddy!';
                }
                return null;
              },
            ),
            if (isStationBeingCreated)
              ElevatedButton(
                onPressed: onRemove,
                child: const Text('Remove Pump'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
