import 'package:flutter/material.dart';
import 'canvas_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final CanvasApiService api = CanvasApiService(
    canvasDomain: 'https://csun.instructure.com',
  );

  List<dynamic> courses = [];
  List<dynamic> assignments = [];
  List<dynamic> files = [];

  bool isLoadingFiles = false;
  bool isLoadingCourses = false;
  bool isLoadingAssignments = false;

  String? errorMessage;
  String? selectedCourseName;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      isLoadingCourses = true;
      errorMessage = null;
    });

    try {
      final result = await api.getCourses();

      setState(() {
        courses = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoadingCourses = false;
      });
    }
  }

  Future<void> _loadCourseContent(int courseId, String courseName) async {
  setState(() {
    isLoadingAssignments = true;
    isLoadingFiles = true;
    assignments = [];
    files = [];
    selectedCourseName = courseName;
    errorMessage = null;
  });

  try {
    final assignmentResult = await api.getAssignments(courseId);
    final fileResult = await api.getCourseFiles(courseId);

    setState(() {
      assignments = assignmentResult;
      files = fileResult;
    });
  } catch (e) {
    setState(() {
      errorMessage = e.toString();
    });
  } finally {
    setState(() {
      isLoadingAssignments = false;
      isLoadingFiles = false;
    });
  }
}

  void _showTokenDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Canvas Token'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Paste your Canvas token here',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final token = controller.text.trim();

                if (token.isEmpty) {
                  return;
                }

                await api.saveToken(token);

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Canvas token saved')),
                );

                _loadCourses();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _disconnectCanvas() async {
    await api.deleteToken();

    setState(() {
      courses = [];
      assignments = [];
      selectedCourseName = null;
      errorMessage = null;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Canvas disconnected')),
    );
  }

  Future<void> _openCanvasFile(dynamic file) async {
  final fileUrl = file['url'];

  if (fileUrl == null || fileUrl.toString().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No file URL available')),
    );
    return;
  }

  final uri = Uri.parse(fileUrl);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open file')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas'),
        actions: [
          IconButton(
            onPressed: _showTokenDialog,
            icon: const Icon(Icons.key),
            tooltip: 'Add Canvas Token',
          ),
          IconButton(
            onPressed: _disconnectCanvas,
            icon: const Icon(Icons.logout),
            tooltip: 'Disconnect Canvas',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'To connect Canvas, go to Canvas → Account → Settings → Approved Integrations → New Access Token. Then paste your token here.',
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _showTokenDialog,
              child: const Text('Connect Canvas'),
            ),

            const SizedBox(height: 20),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            if (isLoadingCourses)
              const CircularProgressIndicator()
            else
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCoursesList(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildAssignmentsList(),
                    ),
                    Expanded(
                      child: _buildFilesList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

  Widget _buildCoursesList() {
    if (courses.isEmpty) {
      return const Center(
        child: Text('No courses loaded yet. Connect Canvas first.'),
      );
    }

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        final courseName = course['name'] ?? 'Unnamed Course';
        final courseId = course['id'];

        return Card(
          child: ListTile(
            title: Text(courseName),
            subtitle: Text('Course ID: $courseId'),
            onTap: () {
              if (courseId != null) {
                _loadCourseContent(courseId, courseName);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildAssignmentsList() {
    if (selectedCourseName == null) {
      return const Center(
        child: Text('Select a course to view assignments.'),
      );
    }

    if (isLoadingAssignments) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (assignments.isEmpty) {
      return Center(
        child: Text('No assignments found for $selectedCourseName.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assignments for $selectedCourseName',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];

              final name = assignment['name'] ?? 'Unnamed Assignment';
              final dueAt = assignment['due_at'] ?? 'No due date';

              return Card(
                child: ListTile(
                  title: Text(name),
                  subtitle: Text('Due: $dueAt'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilesList() {
  if (selectedCourseName == null) {
    return const Center(
      child: Text('Select a course to view files.'),
    );
  }

  if (isLoadingFiles) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (files.isEmpty) {
    return Center(
      child: Text('No files found for $selectedCourseName.'),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Files for $selectedCourseName',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];

            final fileName =
                file['display_name'] ?? file['filename'] ?? 'Unnamed File';

            final contentType = file['content-type'] ?? 'Unknown type';

            return Card(
              child: ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(fileName),
                subtitle: Text(contentType),
                trailing: const Icon(Icons.open_in_new),
                onTap:() {
                  _openCanvasFile(file);
                },
              ),
            );
          },
        ),
      ),
    ],
  );
  }
}