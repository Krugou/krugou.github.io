import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_state.dart';
import 'dart:convert';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;
  
  // Save game state to Firestore
  Future<void> saveGameState(GameState gameState) async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('gameData')
          .doc('currentGame')
          .set({
        'gameState': gameState.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving game state: $e');
      rethrow;
    }
  }
  
  // Load game state from Firestore
  Future<GameState?> loadGameState() async {
    if (_userId == null) return null;
    
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('gameData')
          .doc('currentGame')
          .get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['gameState'] != null) {
          return GameState.fromJson(data['gameState']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error loading game state: $e');
      return null;
    }
  }
  
  // Save user profile
  Future<void> saveUserProfile({
    required String displayName,
    String? bio,
    Map<String, dynamic>? preferences,
  }) async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .set({
        'displayName': displayName,
        'bio': bio,
        'preferences': preferences ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }
  
  // Load user profile
  Future<Map<String, dynamic>?> loadUserProfile() async {
    if (_userId == null) return null;
    
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();
      
      if (doc.exists) {
        return doc.data();
      }
      
      return null;
    } catch (e) {
      print('Error loading user profile: $e');
      return null;
    }
  }
  
  // Get leaderboard data
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('gameData.totalPopulation', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) => {
        'userId': doc.id,
        'displayName': doc.data()['displayName'] ?? 'Anonymous',
        'totalPopulation': doc.data()['gameData']?['totalPopulation'] ?? 0,
        'totalImmigrants': doc.data()['gameData']?['totalImmigrants'] ?? 0,
        'playTime': doc.data()['gameData']?['playTime'] ?? 0,
      }).toList();
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }
  
  // Update last active timestamp
  Future<void> updateLastActive() async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last active: $e');
    }
  }
  
  // Delete user data
  Future<void> deleteUserData() async {
    if (_userId == null) return;
    
    try {
      // Delete game data subcollection
      final gameDataDocs = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('gameData')
          .get();
      
      for (final doc in gameDataDocs.docs) {
        await doc.reference.delete();
      }
      
      // Delete user profile
      await _firestore
          .collection('users')
          .doc(_userId)
          .delete();
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }
}