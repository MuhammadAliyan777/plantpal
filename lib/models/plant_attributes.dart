class PlantAttributes {
  final String min_size;
  final String max_size;
  final String humidity;
  final String water_cycle;
  final String water;
  final String min_sunshine;
  final String max_sunshine;

  PlantAttributes({
    required this.min_size,
    required this.max_size,
    required this.humidity,
    required this.water_cycle,
    required this.water,
    required this.min_sunshine,
    required this.max_sunshine,
  });

  // Convert Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'min_size': min_size,
      'max_size': max_size,
      'humidity': humidity,
      'water_cycle': water_cycle,
      'water': water,
      'min_sunshine': min_sunshine,
      'max_sunshine': max_sunshine,
    };
  }

  // Create a Product object from a map
  factory PlantAttributes.fromMap(Map<String, dynamic> map) {
    return PlantAttributes(
      min_size: map['min_size'],
      max_size: map['max_size'],
      humidity: map['humidity'],
      water_cycle: map['water_cycle'],
      water: map['water'],
      min_sunshine: map['min_sunshine'],
      max_sunshine: map['max_sunshine'],
    );
  }
}
