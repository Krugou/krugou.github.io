class GameState {
  // Single resource: people
  double people;
  
  // Territory system
  List<Territory> territories;
  
  // Event system
  List<GameEvent> eventHistory;
  
  // Game statistics
  int totalImmigrants;
  double playTime;
  DateTime lastSave;
  
  GameState({
    this.people = 1.0,
    List<Territory>? territories,
    List<GameEvent>? eventHistory,
    this.totalImmigrants = 1,
    this.playTime = 0.0,
    DateTime? lastSave,
  }) : territories = territories ?? [Territory.initialTerritory()],
       eventHistory = eventHistory ?? [],
       lastSave = lastSave ?? DateTime.now();
  
  // Get total population across all territories
  double get totalPopulation {
    return territories.fold(0.0, (sum, territory) => sum + territory.population);
  }
  
  // Convert to JSON for saving
  Map<String, dynamic> toJson() {
    return {
      'people': people,
      'territories': territories.map((t) => t.toJson()).toList(),
      'eventHistory': eventHistory.map((e) => e.toJson()).toList(),
      'totalImmigrants': totalImmigrants,
      'playTime': playTime,
      'lastSave': lastSave.millisecondsSinceEpoch,
    };
  }
  
  // Create from JSON for loading
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      people: json['people']?.toDouble() ?? 1.0,
      territories: (json['territories'] as List<dynamic>?)
          ?.map((t) => Territory.fromJson(t))
          .toList() ?? [Territory.initialTerritory()],
      eventHistory: (json['eventHistory'] as List<dynamic>?)
          ?.map((e) => GameEvent.fromJson(e))
          .toList() ?? [],
      totalImmigrants: json['totalImmigrants'] ?? 1,
      playTime: json['playTime']?.toDouble() ?? 0.0,
      lastSave: DateTime.fromMillisecondsSinceEpoch(
        json['lastSave'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

// Territory class for the territory system
class Territory {
  final String id;
  final String name;
  final String description;
  final TerritoryType type;
  double population;
  double capacity;
  bool isUnlocked;
  
  Territory({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.population = 0.0,
    this.capacity = 100.0,
    this.isUnlocked = false,
  });
  
  // Create the initial territory
  factory Territory.initialTerritory() {
    return Territory(
      id: 'village',
      name: 'Rural Village',
      description: 'A small farming community where it all begins',
      type: TerritoryType.rural,
      population: 1.0,
      capacity: 50.0,
      isUnlocked: true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'population': population,
      'capacity': capacity,
      'isUnlocked': isUnlocked,
    };
  }
  
  factory Territory.fromJson(Map<String, dynamic> json) {
    return Territory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: TerritoryType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => TerritoryType.rural,
      ),
      population: json['population']?.toDouble() ?? 0.0,
      capacity: json['capacity']?.toDouble() ?? 100.0,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}

// Territory types
enum TerritoryType {
  rural,
  urban,
  border,
  coastal,
}

// Game event class for the event system
class GameEvent {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final double populationChange;
  final String? targetTerritoryId;
  final DateTime timestamp;
  
  GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.populationChange = 0.0,
    this.targetTerritoryId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'populationChange': populationChange,
      'targetTerritoryId': targetTerritoryId,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
  
  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: EventType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => EventType.immigration,
      ),
      populationChange: json['populationChange']?.toDouble() ?? 0.0,
      targetTerritoryId: json['targetTerritoryId'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}

// Event types
enum EventType {
  immigration,
  emigration,
  disaster,
  opportunity,
  milestone,
}