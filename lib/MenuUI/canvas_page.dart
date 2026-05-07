import 'package:flutter/material.dart';
import 'canvas_api_service.dart';

class RealCanvasPage extends StatefulWidget {
  const RealCanvasPage({super.key});

  @override
  State<RealCanvasPage> createState() => _RealCanvasPageState();
}

class _RealCanvasPageState extends State<RealCanvasPage> {
  final _domainController = TextEditingController();
  final _tokenController = TextEditingController();

  List<dynamic> _courses = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _courses = [];
    });

    try {
      final service = CanvasApiService(
        canvasDomain: _domainController.text.trim(),
        accessToken: _tokenController.text.trim(),
      );

      final courses = await service.getCourses();

      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showAssignments(dynamic course) async {
    try {
      final service = CanvasApiService(
        canvasDomain: _domainController.text.trim(),
        accessToken: _tokenController.text.trim(),
      );

      final assignments = await service.getAssignments(course['id']);

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                course['name'] ?? 'Course',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...assignments.map((assignment) {
                return ListTile(
                  title: Text(assignment['name'] ?? 'Untitled Assignment'),
                  subtitle: Text(
                    assignment['due_at'] == null
                        ? 'No due date'
                        : 'Due: ${assignment['due_at']}',
                  ),
                );
              }),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading assignments: $e')),
      );
    }
  }

  @override
  void dispose() {
    _domainController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Canvas Integration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                labelText: 'Canvas domain',
                hintText: 'https://yourcollege.instructure.com',
              ),
            ),
            TextField(
              controller: _tokenController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Canvas access token',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadCourses,
              child: const Text('Connect Canvas'),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];

                  return Card(
                    child: ListTile(
                      title: Text(course['name'] ?? 'Unnamed Course'),
                      subtitle: Text('Course ID: ${course['id']}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showAssignments(course),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}