import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practice_assignment/data/model.dart';

class LocalStorageService {
  static const String _postsKey = 'cached_posts';
  static const String _lastSyncKey = 'last_sync_time';
  static const int _cacheValidMinutes = 5;
  static Future<void> savePosts(List<DataModel> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = posts.map((post) => post.toJson()).toList();
      await prefs.setString(_postsKey, json.encode(postsJson));
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      throw Exception('Failed to save posts locally: $e');
    }
  }
  static Future<List<DataModel>?> loadPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsString = prefs.getString(_postsKey);
      
      if (postsString != null) {
        final List<dynamic> postsJson = json.decode(postsString);
        return postsJson.map((json) => DataModel.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load posts from local storage: $e');
    }
  }
  static Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncString = prefs.getString(_lastSyncKey);
      return lastSyncString != null ? DateTime.parse(lastSyncString) : null;
    } catch (e) {
      return null;
    }
  }
  static Future<void> clearStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_postsKey);
      await prefs.remove(_lastSyncKey);
    } catch (e) {
      throw Exception('Failed to clear local storage: $e');
    }
  }
  static Future<bool> isDataStale() async {
    try {
      final lastSync = await getLastSyncTime();
      if (lastSync == null) return true;
      
      final now = DateTime.now();
      final difference = now.difference(lastSync);
      return difference.inMinutes > _cacheValidMinutes;
    } catch (e) {
      return true;
    }
  }
}
