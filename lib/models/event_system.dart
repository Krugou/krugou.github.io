import 'dart:math';
import 'game_state.dart';

class EventSystem {
  static final Random _random = Random();
  
  // Territory-specific event pools
  static const Map<TerritoryType, List<EventTemplate>> _territoryEvents = {
    TerritoryType.rural: [
      EventTemplate(
        id: 'rural_harvest',
        title: 'Good Harvest',
        description: 'A successful harvest brings prosperity, attracting families seeking agricultural work.',
        type: EventType.immigration,
        populationChange: 2.0,
        probability: 0.3,
      ),
      EventTemplate(
        id: 'rural_drought',
        title: 'Drought',
        description: 'A severe drought forces some families to seek opportunities elsewhere.',
        type: EventType.emigration,
        populationChange: -1.0,
        probability: 0.1,
      ),
      EventTemplate(
        id: 'rural_newcomers',
        title: 'New Families Arrive',
        description: 'Word spreads about your welcoming community, and new immigrant families arrive.',
        type: EventType.immigration,
        populationChange: 3.0,
        probability: 0.2,
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
      ),
      EventTemplate(
        id: 'urban_housing',
        title: 'Housing Crisis',
        description: 'Rising rents force some families to move to more affordable areas.',
        type: EventType.emigration,
        populationChange: -2.0,
        probability: 0.15,
      ),
      EventTemplate(
        id: 'urban_festival',
        title: 'Cultural Festival',
        description: 'A celebration of immigrant cultures attracts visitors, some of whom decide to stay.',
        type: EventType.immigration,
        populationChange: 4.0,
        probability: 0.1,
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
      ),
      EventTemplate(
        id: 'border_tensions',
        title: 'Border Tensions',
        description: 'Political tensions at the border create uncertainty, causing some to leave.',
        type: EventType.emigration,
        populationChange: -3.0,
        probability: 0.2,
      ),
      EventTemplate(
        id: 'border_aid',
        title: 'Humanitarian Aid',
        description: 'International aid organizations establish support services, attracting displaced families.',
        type: EventType.immigration,
        populationChange: 6.0,
        probability: 0.15,
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
      ),
      EventTemplate(
        id: 'coastal_storm',
        title: 'Coastal Storm',
        description: 'A severe storm damages infrastructure, forcing some residents to relocate.',
        type: EventType.emigration,
        populationChange: -4.0,
        probability: 0.1,
      ),
      EventTemplate(
        id: 'coastal_trade',
        title: 'Trade Routes',
        description: 'New shipping routes bring economic opportunities and immigrant traders.',
        type: EventType.immigration,
        populationChange: 5.0,
        probability: 0.2,
      ),
    ],
  };
  
  // Global milestone events
  static const List<EventTemplate> _milestoneEvents = [
    EventTemplate(
      id: 'milestone_10',
      title: 'Growing Community',
      description: 'Your community reaches 10 people! Word spreads about your welcoming environment.',
      type: EventType.milestone,
      populationChange: 2.0,
      probability: 1.0,
    ),
    EventTemplate(
      id: 'milestone_50',
      title: 'Established Settlement',
      description: 'With 50 people, your settlement becomes well-known. More families seek to join.',
      type: EventType.milestone,
      populationChange: 5.0,
      probability: 1.0,
    ),
    EventTemplate(
      id: 'milestone_100',
      title: 'Thriving Town',
      description: 'Your community of 100 people attracts attention from neighboring regions.',
      type: EventType.milestone,
      populationChange: 10.0,
      probability: 1.0,
    ),
  ];
  
  // Generate a random event for a territory
  static GameEvent? generateEvent(Territory territory) {
    final eventPool = _territoryEvents[territory.type] ?? [];
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
  static GameEvent? checkMilestoneEvent(double totalPopulation) {
    for (final template in _milestoneEvents) {
      if (template.id == 'milestone_10' && totalPopulation >= 10) {
        return _createEventFromTemplate(template, null);
      } else if (template.id == 'milestone_50' && totalPopulation >= 50) {
        return _createEventFromTemplate(template, null);
      } else if (template.id == 'milestone_100' && totalPopulation >= 100) {
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
    );
  }
  
  // Get available territories to unlock based on population
  static List<Territory> getAvailableTerritories(double totalPopulation) {
    final availableTerritories = <Territory>[];
    
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
    
    return availableTerritories;
  }
}

// Event template for defining possible events
class EventTemplate {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final double populationChange;
  final double probability;
  
  const EventTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.populationChange,
    required this.probability,
  });
}