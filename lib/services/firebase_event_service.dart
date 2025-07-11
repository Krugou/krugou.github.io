import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event_system.dart';
import '../models/game_state.dart';
import 'dart:convert';

class FirebaseEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;
  
  // Collection references
  CollectionReference get _eventsCollection => _firestore.collection('events');
  CollectionReference get _userEventsCollection => _firestore.collection('users').doc(_userId).collection('customEvents');
  
  // Load events from Firebase (fallback to JSON if Firebase fails)
  Future<Map<TerritoryType, List<EventTemplate>>> loadTerritoryEvents() async {
    try {
      // Try to load from Firebase first
      final snapshot = await _eventsCollection.doc('territory_events').get();
      
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        return _parseTerritoryEventsFromFirebase(data);
      }
      
      // Fallback to JSON loading
      print('Firebase events not available, falling back to JSON');
      return await _loadEventsFromJson();
    } catch (e) {
      print('Error loading events from Firebase: $e');
      // Fallback to JSON
      return await _loadEventsFromJson();
    }
  }
  
  // Load milestone events from Firebase
  Future<List<EventTemplate>> loadMilestoneEvents() async {
    try {
      final snapshot = await _eventsCollection.doc('milestone_events').get();
      
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        return _parseMilestoneEventsFromFirebase(data);
      }
      
      // Fallback to JSON loading
      print('Firebase milestone events not available, falling back to JSON');
      return await _loadMilestoneEventsFromJson();
    } catch (e) {
      print('Error loading milestone events from Firebase: $e');
      return await _loadMilestoneEventsFromJson();
    }
  }
  
  // Add new event to Firebase
  Future<void> addEvent(EventTemplate event, {bool isCustom = false}) async {
    try {
      final eventData = event.toJson();
      
      if (isCustom && _userId != null) {
        // Add to user's custom events
        await _userEventsCollection.doc(event.id).set(eventData);
      } else {
        // Add to global events (requires admin permissions)
        await _eventsCollection.doc('custom_events').collection('events').doc(event.id).set(eventData);
      }
    } catch (e) {
      print('Error adding event to Firebase: $e');
      rethrow;
    }
  }
  
  // Update existing event in Firebase
  Future<void> updateEvent(EventTemplate event, {bool isCustom = false}) async {
    try {
      final eventData = event.toJson();
      
      if (isCustom && _userId != null) {
        await _userEventsCollection.doc(event.id).update(eventData);
      } else {
        await _eventsCollection.doc('custom_events').collection('events').doc(event.id).update(eventData);
      }
    } catch (e) {
      print('Error updating event in Firebase: $e');
      rethrow;
    }
  }
  
  // Delete event from Firebase
  Future<void> deleteEvent(String eventId, {bool isCustom = false}) async {
    try {
      if (isCustom && _userId != null) {
        await _userEventsCollection.doc(eventId).delete();
      } else {
        await _eventsCollection.doc('custom_events').collection('events').doc(eventId).delete();
      }
    } catch (e) {
      print('Error deleting event from Firebase: $e');
      rethrow;
    }
  }
  
  // Get all events for management (used by Python Qt backend)
  Future<List<EventTemplate>> getAllEvents() async {
    try {
      final List<EventTemplate> allEvents = [];
      
      // Load territory events
      final territoryEvents = await loadTerritoryEvents();
      for (final events in territoryEvents.values) {
        allEvents.addAll(events);
      }
      
      // Load milestone events
      final milestoneEvents = await loadMilestoneEvents();
      allEvents.addAll(milestoneEvents);
      
      // Load custom events
      final customEvents = await _loadCustomEvents();
      allEvents.addAll(customEvents);
      
      return allEvents;
    } catch (e) {
      print('Error getting all events: $e');
      return [];
    }
  }
  
  // Load custom events from Firebase
  Future<List<EventTemplate>> _loadCustomEvents() async {
    try {
      final snapshot = await _eventsCollection.doc('custom_events').collection('events').get();
      return snapshot.docs.map((doc) => EventTemplate.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error loading custom events: $e');
      return [];
    }
  }
  
  // Upload JSON events to Firebase (for initial setup)
  Future<void> uploadJsonEventsToFirebase() async {
    try {
      // This method should be called once to migrate JSON events to Firebase
      final territoryEvents = await _loadEventsFromJson();
      final milestoneEvents = await _loadMilestoneEventsFromJson();
      
      // Upload territory events
      final territoryEventsData = <String, dynamic>{};
      for (final entry in territoryEvents.entries) {
        territoryEventsData[entry.key.name] = entry.value.map((e) => e.toJson()).toList();
      }
      await _eventsCollection.doc('territory_events').set(territoryEventsData);
      
      // Upload milestone events
      final milestoneEventsData = {
        'milestones': milestoneEvents.map((e) => e.toJson()).toList(),
      };
      await _eventsCollection.doc('milestone_events').set(milestoneEventsData);
      
      print('Successfully uploaded JSON events to Firebase');
    } catch (e) {
      print('Error uploading JSON events to Firebase: $e');
      rethrow;
    }
  }
  
  // Parse territory events from Firebase data
  Map<TerritoryType, List<EventTemplate>> _parseTerritoryEventsFromFirebase(Map<String, dynamic> data) {
    final Map<TerritoryType, List<EventTemplate>> territoryEvents = {};
    
    for (final entry in data.entries) {
      final territoryType = TerritoryType.values.firstWhere(
        (type) => type.name == entry.key,
        orElse: () => TerritoryType.rural,
      );
      
      territoryEvents[territoryType] = (entry.value as List)
          .map((eventData) => EventTemplate.fromJson(eventData))
          .toList();
    }
    
    return territoryEvents;
  }
  
  // Parse milestone events from Firebase data
  List<EventTemplate> _parseMilestoneEventsFromFirebase(Map<String, dynamic> data) {
    return (data['milestones'] as List)
        .map((eventData) => EventTemplate.fromJson(eventData))
        .toList();
  }
  
  // Fallback JSON loading methods
  Future<Map<TerritoryType, List<EventTemplate>>> _loadEventsFromJson() async {
    try {
      final territoryEventsJson = await _loadJsonAsset('assets/events/territory_events.json');
      final territoryEventsData = jsonDecode(territoryEventsJson);
      return _parseTerritoryEventsFromFirebase(territoryEventsData);
    } catch (e) {
      print('Error loading territory events from JSON: $e');
      return {};
    }
  }
  
  Future<List<EventTemplate>> _loadMilestoneEventsFromJson() async {
    try {
      final milestoneEventsJson = await _loadJsonAsset('assets/events/milestone_events.json');
      final milestoneEventsData = jsonDecode(milestoneEventsJson);
      return _parseMilestoneEventsFromFirebase(milestoneEventsData);
    } catch (e) {
      print('Error loading milestone events from JSON: $e');
      return [];
    }
  }
  
  // Load JSON asset - this will be imported from existing system
  Future<String> _loadJsonAsset(String path) async {
    // This would use rootBundle.loadString in actual implementation
    // For now, we'll return empty string and handle in calling code
    throw UnimplementedError('JSON asset loading not implemented in this context');
  }
  
  // Stream events for real-time updates
  Stream<List<EventTemplate>> getEventsStream() {
    return _eventsCollection.snapshots().map((snapshot) {
      final allEvents = <EventTemplate>[];
      
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          
          // Handle different document types
          if (doc.id == 'territory_events') {
            final territoryEvents = _parseTerritoryEventsFromFirebase(data);
            for (final events in territoryEvents.values) {
              allEvents.addAll(events);
            }
          } else if (doc.id == 'milestone_events') {
            final milestoneEvents = _parseMilestoneEventsFromFirebase(data);
            allEvents.addAll(milestoneEvents);
          }
        } catch (e) {
          print('Error parsing event document ${doc.id}: $e');
        }
      }
      
      return allEvents;
    });
  }
  
  // Check if Firebase is available
  Future<bool> isFirebaseAvailable() async {
    try {
      await _firestore.doc('health/check').get();
      return true;
    } catch (e) {
      return false;
    }
  }
}