import 'dart:convert';
import 'package:http/http.dart' as http;

class CanvasApiService {
  final String canvasDomain;
  final String accessToken;

  CanvasApiService({
    required this.canvasDomain,
    required this.accessToken,
  });

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $accessToken',
      };

  Future<List<dynamic>> getCourses() async {
    final url = Uri.parse('$canvasDomain/api/v1/courses');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load courses: ${response.body}');
    }
  }

  Future<List<dynamic>> getAssignments(int courseId) async {
    final url = Uri.parse(
      '$canvasDomain/api/v1/courses/$courseId/assignments',
    );

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load assignments: ${response.body}');
    }
  }
}