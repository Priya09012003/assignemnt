import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practice_assignment/data/model.dart';
import 'package:practice_assignment/data/local_storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Repository {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  final int _timeoutSeconds = 10;

  Future<List<DataModel>> getPosts() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;
      print(' Network Status: ${isOnline ? "ONLINE" : "OFFLINE"}');

      List<DataModel>? localPosts = await LocalStorageService.loadPosts();
      print('Local Posts Found: ${localPosts?.length ?? 0}');

      if (isOnline) {
        try {
          final response = await http.get(Uri.parse(baseUrl)).timeout(Duration(seconds: _timeoutSeconds));
          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            final apiPosts = data.map((e) => DataModel.fromJson(e)).toList();
            print(' API Posts Fetched: ${apiPosts.length}');

            final mergedPosts = _mergePostsWithLocalData(apiPosts, localPosts);
            await LocalStorageService.savePosts(mergedPosts);
            print(' Posts Saved to Local Storage');
            return mergedPosts;
          } else {
            throw Exception('Failed to fetch posts: ${response.statusCode}');
          }
        } catch (e) {
          print(' API Error, falling back to local data');
          if (localPosts != null && localPosts.isNotEmpty) {
            print(' Using Local Data: ${localPosts.length} posts');
            return localPosts;
          }
          throw Exception('Network error: Unable to fetch posts. Please check your internet connection.');
        }
      } else {
        print(' Offline Mode - Using Local Data');
        if (localPosts != null && localPosts.isNotEmpty) {
          print(' Local Posts Available: ${localPosts.length}');
          return localPosts;
        }
        throw Exception(
          'No internet connection and no cached data available. Please connect to the internet to load posts.',
        );
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  List<DataModel> _mergePostsWithLocalData(List<DataModel> apiPosts, List<DataModel>? localPosts) {
    if (localPosts == null) return apiPosts;

    final localPostsMap = {for (var post in localPosts) post.id: post};

    return apiPosts.map((apiPost) {
      final localPost = localPostsMap[apiPost.id];
      if (localPost != null) {
        return DataModel(
          id: apiPost.id,
          userId: apiPost.userId,
          title: apiPost.title,
          body: apiPost.body,
          isRead: localPost.isRead,
          timer: localPost.timer,
        );
      }
      return apiPost;
    }).toList();
  }

  Future<DataModel> getPostDetail(int postId) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;

      if (isOnline) {
        try {
          final response = await http.get(Uri.parse('$baseUrl/$postId')).timeout(Duration(seconds: _timeoutSeconds));
          if (response.statusCode == 200) {
            return DataModel.fromJson(json.decode(response.body));
          } else {
            throw Exception('Failed to fetch post details: ${response.statusCode}');
          }
        } catch (e) {
          throw Exception('Network error: Unable to fetch post details. Please check your internet connection.');
        }
      } else {
        throw Exception('No internet connection. Please connect to the internet to view post details.');
      }
    } catch (e) {
      throw Exception('Error fetching post details: $e');
    }
  }
}
