import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class CanvasApiService {
  final String canvasDomain;

  // Secure storage for token
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  CanvasApiService({
    required this.canvasDomain,
  });

  // Get headers with token
  Future<Map<String, String>> get _headers async {
    final token = await _storage.read(key: 'canvas_token');

    if (token == null || token.isEmpty) {
      throw Exception('No Canvas token found. Please add one.');
    }

    return {
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'canvas_token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'canvas_token');
  }

  // Get courses
  Future<List<dynamic>> getCourses() async {
    //For web testing, use the following URL:
    final url = kIsWeb
    ? Uri.parse('http://localhost:3000/canvas/courses')
    : Uri.parse(
        '$canvasDomain/api/v1/courses?include[]=term&per_page=100',
      );

    //For iOS sumulator testing, use the following URL instead of the localhost URL:
 //   final url = Uri.parse('$canvasDomain/api/v1/courses'
   // '?enrollment_state=active'
  //'?include[]=term'
  //'?include[]=total_scores'
  //'?per_page=100',
//);

    final response = await http.get(url, headers: await _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load courses: ${response.body}');
    }
  }

  // Get assignments
 Future<List<dynamic>> getAssignments(int courseId) async {
  //For web testing, use the following URL:
  final url = kIsWeb
    ? Uri.parse(
        'http://localhost:3000/canvas/courses/$courseId/assignments',
      )
    : Uri.parse(
        '$canvasDomain/api/v1/courses/$courseId/assignments?per_page=100',
      );

//For iOS sumulator testing, use the following URL instead of the localhost URL:
 // final url = Uri.parse(
  //  '$canvasDomain/api/v1/courses/$courseId/assignments'
  //  '?per_page=100'
  //  '&include[]=all_dates'
  //  '&include[]=submission',
  //);

  return await _getAllPages(url);
}

  Future<List<dynamic>> _getAllPages(Uri firstUrl) async {
  final allItems = <dynamic>[];
  Uri? url = firstUrl;

  while (url != null) {
    final response = await http.get(url, headers: await _headers);

    if (response.statusCode != 200) {
      throw Exception('Canvas API error: ${response.body}');
    }

    allItems.addAll(jsonDecode(response.body));

    final linkHeader = response.headers['link'];
    url = _getNextPageUrl(linkHeader);
  }

  return allItems;
}

Uri? _getNextPageUrl(String? linkHeader) {
  if (linkHeader == null) return null;

  final links = linkHeader.split(',');

  for (final link in links) {
    if (link.contains('rel="next"')) {
      final match = RegExp(r'<([^>]+)>').firstMatch(link);
      if (match != null) {
        return Uri.parse(match.group(1)!);
      }
    }
  }

  return null;
}

Future<List<dynamic>> getCourseFiles(int courseId) async {
  //For web testing, use the following URL:
  final url = kIsWeb
    ? Uri.parse(
        'http://localhost:3000/canvas/courses/$courseId/files',
      )
    : Uri.parse(
        '$canvasDomain/api/v1/courses/$courseId/files?per_page=100',
      );

  //For iOS sumulator testing, use the following URL instead of the localhost URL:
  //final url = Uri.parse(
   // '$canvasDomain/api/v1/courses/$courseId/files?per_page=100',
  //);

  return await _getAllPages(url);
}
}