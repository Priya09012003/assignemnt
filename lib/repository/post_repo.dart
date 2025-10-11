import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practice_assignment/data/model.dart';

class Repository {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<DataModel>> getPosts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => DataModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  Future<DataModel> getPostDetail(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$postId')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return DataModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch post details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching post details: $e');
    }
  }
}
