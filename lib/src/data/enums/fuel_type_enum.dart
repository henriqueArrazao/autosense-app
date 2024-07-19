enum FuelTypeEnum {
  benzin95,
  benzin98,
  diesel,
  ethanol,
  lpg;

  static FuelTypeEnum fromString(String text) {
    return FuelTypeEnum.values.firstWhere(
      (FuelTypeEnum fuelType) => fuelType.toString() == text,
    );
  }

  @override
  String toString() {
    switch (this) {
      case FuelTypeEnum.benzin95:
        return 'benzin95';
      case FuelTypeEnum.benzin98:
        return 'benzin98';
      case FuelTypeEnum.diesel:
        return 'diesel';
      case FuelTypeEnum.ethanol:
        return 'ethanol';
      case FuelTypeEnum.lpg:
        return 'lpg';
      default:
        throw Exception(
            'FuelTypeEnum.toString: $this is not a valid FuelTypeEnum');
    }
  }
}
