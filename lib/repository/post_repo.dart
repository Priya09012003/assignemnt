import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../data/model.dart';
import '../data/local_storage_service.dart';

class Repository {
  final String baseUrl = "https://jsonplaceholder.typicode.com/posts";
  final int timeoutSec = 10;

  /// Fetch all posts (online → sync → save local, offline → load local)
  Future<List<DataModel>> getPosts() async {
    final isOnline = await _checkInternet();
    final cached = await LocalStorageService.loadPosts();

    if (!isOnline) {
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
      throw Exception("No internet and no local data available.");
    }

    // Online mode
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(Duration(seconds: timeoutSec));

      if (response.statusCode != 200) {
        throw Exception("Failed to load posts");
      }

      final List list = jsonDecode(response.body);
      final apiPosts = list.map((e) => DataModel.fromJson(e)).toList();

      // Merge read + timer states from local cache
      final merged = _mergeLocal(apiPosts, cached);

      await LocalStorageService.savePosts(merged);

      return merged;
    } catch (e) {
      // Fallback to cache
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
      throw Exception("Unable to fetch posts. Check your internet.");
    }
  }

  /// Fetch a single post detail
  Future<DataModel> getPostDetail(int id) async {
    final isOnline = await _checkInternet();

    if (!isOnline) {
      throw Exception("You are offline. Please connect to view details.");
    }

    try {
      final response = await http.get(Uri.parse("$baseUrl/$id")).timeout(Duration(seconds: timeoutSec));

      if (response.statusCode != 200) {
        throw Exception("Failed to load post");
      }

      return DataModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception("Unable to load post detail.");
    }
  }

  /// Merge isRead + timer from local cache
  List<DataModel> _mergeLocal(List<DataModel> api, List<DataModel>? local) {
    if (local == null) return api;

    for (var i = 0; i < api.length; i++) {
      final match = local.firstWhere((p) => p.id == api[i].id, orElse: () => api[i]);

      api[i].isRead = match.isRead;
      api[i].timer = match.timer;
    }

    return api;
  }

  /// Check connectivity
  Future<bool> _checkInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
