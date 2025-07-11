import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'game_state.dart';

class EventSystem {
  static final Random _random = Random();
  static Map<TerritoryType, List<EventTemplate>>? _territoryEvents;
  static List<EventTemplate>? _milestoneEvents;
  static bool _isInitialized = false;
  
  // Initialize event system by loading JSON data
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load territory events
      final territoryEventsJson = await rootBundle.loadString('assets/events/territory_events.json');
      final territoryEventsData = jsonDecode(territoryEventsJson);
      
      // Load milestone events
      final milestoneEventsJson = await rootBundle.loadString('assets/events/milestone_events.json');
      final milestoneEventsData = jsonDecode(milestoneEventsJson);
      
      // Parse territory events
      _territoryEvents = {};
      for (final entry in territoryEventsData.entries) {
        final territoryType = TerritoryType.values.firstWhere(
          (type) => type.name == entry.key,
          orElse: () => TerritoryType.rural,
        );
        
        _territoryEvents![territoryType] = (entry.value as List)
            .map((eventData) => EventTemplate.fromJson(eventData))
            .toList();
      }
      
      // Parse milestone events
      _milestoneEvents = (milestoneEventsData['milestones'] as List)
          .map((eventData) => EventTemplate.fromJson(eventData))
          .toList();
      
      _isInitialized = true;
    } catch (e) {
      print('Error loading event data: $e');
      // Fallback to hardcoded events if JSON loading fails
      _initializeHardcodedEvents();
    }
  }
  
  // Fallback method with hardcoded events (keeping existing functionality)
  static void _initializeHardcodedEvents() {
    _territoryEvents = {
      TerritoryType.rural: [
        EventTemplate(
          id: 'rural_harvest',
          title: 'Good Harvest',
          description: 'A successful harvest brings prosperity, attracting families seeking agricultural work.',
          type: EventType.immigration,
          populationChange: 2.0,
          probability: 0.3,
          category: 'opportunity',
        ),
        EventTemplate(
          id: 'rural_drought',
          title: 'Drought',
          description: 'A severe drought forces some families to seek opportunities elsewhere.',
          type: EventType.emigration,
          populationChange: -1.0,
          probability: 0.1,
          category: 'disaster',
        ),
        EventTemplate(
          id: 'rural_newcomers',
          title: 'New Families Arrive',
          description: 'Word spreads about your welcoming community, and new immigrant families arrive.',
          type: EventType.immigration,
          populationChange: 3.0,
          probability: 0.2,
          category: 'opportunity',
        ),
      ],
      TerritoryType.urban: [
        EventTemplate(
          id: 'urban_jobs',
          title: 'Job Opportunities',
          description: 'New businesses open, creating jobs that attract workers from rural areas.',
          type: EventType.immigration,
          populationChange: 5.0,
          probability: 0.4,
          category: 'opportunity',
        ),
        EventTemplate(
          id: 'urban_housing',
          title: 'Housing Crisis',
          description: 'Rising rents force some families to move to more affordable areas.',
          type: EventType.emigration,
          populationChange: -2.0,
          probability: 0.15,
          category: 'conflict',
        ),
        EventTemplate(
          id: 'urban_festival',
          title: 'Cultural Festival',
          description: 'A celebration of immigrant cultures attracts visitors, some of whom decide to stay.',
          type: EventType.immigration,
          populationChange: 4.0,
          probability: 0.1,
          category: 'opportunity',
        ),
      ],
      TerritoryType.border: [
        EventTemplate(
          id: 'border_crossing',
          title: 'Border Crossing',
          description: 'A group of refugees seeks asylum, finding safety in your community.',
          type: EventType.immigration,
          populationChange: 8.0,
          probability: 0.3,
          category: 'opportunity',
        ),
        EventTemplate(
          id: 'border_tensions',
          title: 'Border Tensions',
          description: 'Political tensions at the border create uncertainty, causing some to leave.',
          type: EventType.emigration,
          populationChange: -3.0,
          probability: 0.2,
          category: 'conflict',
        ),
        EventTemplate(
          id: 'border_aid',
          title: 'Humanitarian Aid',
          description: 'International aid organizations establish support services, attracting displaced families.',
          type: EventType.immigration,
          populationChange: 6.0,
          probability: 0.15,
          category: 'opportunity',
        ),
      ],
      TerritoryType.coastal: [
        EventTemplate(
          id: 'coastal_fishing',
          title: 'Abundant Fishing',
          description: 'Rich fishing grounds attract maritime workers and their families.',
          type: EventType.immigration,
          populationChange: 3.0,
          probability: 0.25,
          category: 'opportunity',
        ),
        EventTemplate(
          id: 'coastal_storm',
          title: 'Coastal Storm',
          description: 'A severe storm damages infrastructure, forcing some residents to relocate.',
          type: EventType.emigration,
          populationChange: -4.0,
          probability: 0.1,
          category: 'disaster',
        ),
        EventTemplate(
          id: 'coastal_trade',
          title: 'Trade Routes',
          description: 'New shipping routes bring economic opportunities and immigrant traders.',
          type: EventType.immigration,
          populationChange: 5.0,
          probability: 0.2,
          category: 'opportunity',
        ),
      ],
      // Add new territory types with basic events
      TerritoryType.caves: [
        EventTemplate(
          id: 'caves_shelter',
          title: 'Natural Shelter',
          description: 'Cave systems provide protection from harsh weather, attracting desperate families.',
          type: EventType.immigration,
          populationChange: 4.0,
          probability: 0.3,
          category: 'opportunity',
        ),
      ],
      TerritoryType.underground: [
        EventTemplate(
          id: 'underground_tunnels',
          title: 'Tunnel Network',
          description: 'Hidden tunnels provide safe passage for refugees escaping persecution.',
          type: EventType.immigration,
          populationChange: 7.0,
          probability: 0.25,
          category: 'opportunity',
        ),
      ],
      TerritoryType.mountains: [
        EventTemplate(
          id: 'mountains_refuge',
          title: 'Mountain Refuge',
          description: 'High altitude settlements offer isolation and safety from conflicts below.',
          type: EventType.immigration,
          populationChange: 5.0,
          probability: 0.3,
          category: 'opportunity',
        ),
      ],
      TerritoryType.desert: [
        EventTemplate(
          id: 'desert_oasis',
          title: 'Oasis Discovery',
          description: 'A hidden oasis provides water and shelter for desert travelers.',
          type: EventType.immigration,
          populationChange: 4.0,
          probability: 0.25,
          category: 'opportunity',
        ),
      ],
      TerritoryType.arctic: [
        EventTemplate(
          id: 'arctic_research',
          title: 'Research Station',
          description: 'Scientific research facilities attract researchers and support staff.',
          type: EventType.immigration,
          populationChange: 3.0,
          probability: 0.2,
          category: 'opportunity',
        ),
      ],
      TerritoryType.orbital: [
        EventTemplate(
          id: 'orbital_construction',
          title: 'Orbital Construction',
          description: 'Space station construction projects attract skilled workers and engineers.',
          type: EventType.immigration,
          populationChange: 4.0,
          probability: 0.25,
          category: 'opportunity',
        ),
      ],
      TerritoryType.space_station: [
        EventTemplate(
          id: 'space_station_trade',
          title: 'Interplanetary Trade',
          description: 'Space station becomes a hub for interplanetary commerce and migration.',
          type: EventType.immigration,
          populationChange: 8.0,
          probability: 0.3,
          category: 'opportunity',
        ),
      ],
    };
    
    _milestoneEvents = [
      EventTemplate(
        id: 'milestone_10',
        title: 'Growing Community',
        description: 'Your community reaches 10 people! Word spreads about your welcoming environment.',
        type: EventType.milestone,
        populationChange: 2.0,
        probability: 1.0,
        category: 'milestone',
        threshold: 10,
      ),
      EventTemplate(
        id: 'milestone_50',
        title: 'Established Settlement',
        description: 'With 50 people, your settlement becomes well-known. More families seek to join.',
        type: EventType.milestone,
        populationChange: 5.0,
        probability: 1.0,
        category: 'milestone',
        threshold: 50,
      ),
      EventTemplate(
        id: 'milestone_100',
        title: 'Thriving Town',
        description: 'Your community of 100 people attracts attention from neighboring regions.',
        type: EventType.milestone,
        populationChange: 10.0,
        probability: 1.0,
        category: 'milestone',
        threshold: 100,
      ),
    ];
    
    _isInitialized = true;
  }
  
  // Generate a random event for a territory
  static GameEvent? generateEvent(Territory territory) {
    if (!_isInitialized) return null;
    
    final eventPool = _territoryEvents![territory.type] ?? [];
    if (eventPool.isEmpty) return null;
    
    // Try to trigger an event based on probability
    for (final template in eventPool) {
      if (_random.nextDouble() < template.probability) {
        return _createEventFromTemplate(template, territory);
      }
    }
    
    return null;
  }
  
  // Check for milestone events
  static GameEvent? checkMilestoneEvent(double totalPopulation, List<String> achievedMilestones) {
    if (!_isInitialized || _milestoneEvents == null) return null;
    
    for (final template in _milestoneEvents!) {
      if (template.threshold != null && 
          totalPopulation >= template.threshold! && 
          !achievedMilestones.contains(template.id)) {
        return _createEventFromTemplate(template, null);
      }
    }
    return null;
  }
  
  // Create a GameEvent from a template
  static GameEvent _createEventFromTemplate(EventTemplate template, Territory? territory) {
    return GameEvent(
      id: '${template.id}_${DateTime.now().millisecondsSinceEpoch}',
      title: template.title,
      description: template.description,
      type: template.type,
      populationChange: template.populationChange,
      targetTerritoryId: territory?.id,
      category: template.category,
    );
  }
  
  // Get available territories to unlock based on population with expanded progression
  static List<Territory> getAvailableTerritories(double totalPopulation) {
    final availableTerritories = <Territory>[];
    
    // Existing territories
    if (totalPopulation >= 25) {
      availableTerritories.add(Territory(
        id: 'urban_center',
        name: 'Urban Center',
        description: 'A bustling city with job opportunities and cultural diversity',
        type: TerritoryType.urban,
        capacity: 200.0,
      ));
    }
    
    if (totalPopulation >= 50) {
      availableTerritories.add(Territory(
        id: 'border_town',
        name: 'Border Town',
        description: 'A strategic location for those seeking refuge and new beginnings',
        type: TerritoryType.border,
        capacity: 150.0,
      ));
    }
    
    if (totalPopulation >= 75) {
      availableTerritories.add(Territory(
        id: 'coastal_port',
        name: 'Coastal Port',
        description: 'A maritime hub with fishing and trade opportunities',
        type: TerritoryType.coastal,
        capacity: 175.0,
      ));
    }
    
    // New territories - progression from caves to space stations
    if (totalPopulation >= 100) {
      availableTerritories.add(Territory(
        id: 'cave_network',
        name: 'Cave Network',
        description: 'Underground caves providing shelter and protection',
        type: TerritoryType.caves,
        capacity: 120.0,
      ));
    }
    
    if (totalPopulation >= 150) {
      availableTerritories.add(Territory(
        id: 'underground_city',
        name: 'Underground City',
        description: 'A hidden city beneath the surface with advanced facilities',
        type: TerritoryType.underground,
        capacity: 250.0,
      ));
    }
    
    if (totalPopulation >= 200) {
      availableTerritories.add(Territory(
        id: 'mountain_settlement',
        name: 'Mountain Settlement',
        description: 'High-altitude community with stunning views and clean air',
        type: TerritoryType.mountains,
        capacity: 180.0,
      ));
    }
    
    if (totalPopulation >= 300) {
      availableTerritories.add(Territory(
        id: 'desert_outpost',
        name: 'Desert Outpost',
        description: 'Solar-powered settlement in the harsh desert environment',
        type: TerritoryType.desert,
        capacity: 150.0,
      ));
    }
    
    if (totalPopulation >= 400) {
      availableTerritories.add(Territory(
        id: 'arctic_base',
        name: 'Arctic Base',
        description: 'Research and residential facilities in the frozen wilderness',
        type: TerritoryType.arctic,
        capacity: 100.0,
      ));
    }
    
    if (totalPopulation >= 500) {
      availableTerritories.add(Territory(
        id: 'orbital_platform',
        name: 'Orbital Platform',
        description: 'Space-based habitat orbiting Earth',
        type: TerritoryType.orbital,
        capacity: 200.0,
      ));
    }
    
    if (totalPopulation >= 750) {
      availableTerritories.add(Territory(
        id: 'space_station_alpha',
        name: 'Space Station Alpha',
        description: 'Advanced interplanetary hub for deep space exploration',
        type: TerritoryType.space_station,
        capacity: 300.0,
      ));
    }
    
    return availableTerritories;
  }
  
  // Get all available event categories
  static List<String> getEventCategories() {
    return ['opportunity', 'disaster', 'conflict', 'epidemic', 'milestone', 'achievement'];
  }
  
  // Get events by category
  static List<EventTemplate> getEventsByCategory(String category) {
    if (!_isInitialized) return [];
    
    final events = <EventTemplate>[];
    
    // Add territory events
    for (final territoryEvents in _territoryEvents!.values) {
      events.addAll(territoryEvents.where((event) => event.category == category));
    }
    
    // Add milestone events
    if (_milestoneEvents != null) {
      events.addAll(_milestoneEvents!.where((event) => event.category == category));
    }
    
    return events;
  }
}

// Enhanced event template with JSON support
class EventTemplate {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final double populationChange;
  final double probability;
  final String category;
  final int? threshold;
  final String? trigger;
  final String? territoryType;
  
  const EventTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.populationChange,
    required this.probability,
    required this.category,
    this.threshold,
    this.trigger,
    this.territoryType,
  });
  
  // Create from JSON
  factory EventTemplate.fromJson(Map<String, dynamic> json) {
    return EventTemplate(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: EventType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => EventType.immigration,
      ),
      populationChange: json['populationChange']?.toDouble() ?? 0.0,
      probability: json['probability']?.toDouble() ?? 0.1,
      category: json['category'] ?? 'opportunity',
      threshold: json['threshold'],
      trigger: json['trigger'],
      territoryType: json['territoryType'],
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'populationChange': populationChange,
      'probability': probability,
      'category': category,
      'threshold': threshold,
      'trigger': trigger,
      'territoryType': territoryType,
    };
  }
}