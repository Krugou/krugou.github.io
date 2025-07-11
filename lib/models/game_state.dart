class GameState {
  double population;
  double food;
  double housing;
  double happiness;
  
  // Upgrade counts
  int farms;
  int houses;
  int schools;
  int hospitals;
  int ports;
  int workshops;
  
  // Game statistics
  int totalImmigrants;
  double playTime;
  DateTime lastSave;
  
  GameState({
    this.population = 1.0,
    this.food = 10.0,
    this.housing = 5.0,
    this.happiness = 50.0,
    this.farms = 0,
    this.houses = 0,
    this.schools = 0,
    this.hospitals = 0,
    this.ports = 0,
    this.workshops = 0,
    this.totalImmigrants = 1,
    this.playTime = 0.0,
    DateTime? lastSave,
  }) : lastSave = lastSave ?? DateTime.now();
  
  // Convert to JSON for saving
  Map<String, dynamic> toJson() {
    return {
      'population': population,
      'food': food,
      'housing': housing,
      'happiness': happiness,
      'farms': farms,
      'houses': houses,
      'schools': schools,
      'hospitals': hospitals,
      'ports': ports,
      'workshops': workshops,
      'totalImmigrants': totalImmigrants,
      'playTime': playTime,
      'lastSave': lastSave.millisecondsSinceEpoch,
    };
  }
  
  // Create from JSON for loading
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      population: json['population']?.toDouble() ?? 1.0,
      food: json['food']?.toDouble() ?? 10.0,
      housing: json['housing']?.toDouble() ?? 5.0,
      happiness: json['happiness']?.toDouble() ?? 50.0,
      farms: json['farms'] ?? 0,
      houses: json['houses'] ?? 0,
      schools: json['schools'] ?? 0,
      hospitals: json['hospitals'] ?? 0,
      ports: json['ports'] ?? 0,
      workshops: json['workshops'] ?? 0,
      totalImmigrants: json['totalImmigrants'] ?? 1,
      playTime: json['playTime']?.toDouble() ?? 0.0,
      lastSave: DateTime.fromMillisecondsSinceEpoch(
        json['lastSave'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}