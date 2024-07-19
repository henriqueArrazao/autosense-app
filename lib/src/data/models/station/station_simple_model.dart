class StationSimpleModel {
  final int id;
  final double latitude;
  final double longitude;

  StationSimpleModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory StationSimpleModel.fromJson(Map<String, dynamic> json) {
    return StationSimpleModel(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
