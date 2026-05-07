import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class StudyBoardMenuUI extends StatefulWidget {
  static const routeName = '/studyBoardMenu';

  const StudyBoardMenuUI({super.key});

  @override
  State<StudyBoardMenuUI> createState() => _StudyBoardMenuUIState();
}

class _StudyBoardMenuUIState extends State<StudyBoardMenuUI> {
  TextEditingController taskController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  List<String> uploadedPdfs = [];

  void uploadPdf() async {
    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);

    if (result != null) {
      setState(() {
        uploadedPdfs.add(result.files.single.name);
      });
    }
  }

  void deletePdf(int index) {
    setState(() {
      uploadedPdfs.removeAt(index);
    });
  }

  void addTask() {
    String taskName = taskController.text.trim();
    if (taskName.isEmpty) return;
    setState(() {
      tasks.add({'name': taskName, 'done': false});
    });
    taskController.clear();
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index]['done'] = !tasks[index]['done'];
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Board'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 47, 158, 249),
              Color.fromARGB(255, 197, 227, 252),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'My Tasks',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        hintText: 'Add a new task...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addTask,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks yet. Add one above!',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          bool isDone = tasks[index]['done'];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: isDone,
                                onChanged: (value) => toggleTask(index),
                              ),
                              title: Text(
                                tasks[index]['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: isDone ? Colors.grey : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteTask(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                'My PDFs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: uploadPdf,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload PDF'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (uploadedPdfs.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: uploadedPdfs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        title: Text(
                          uploadedPdfs[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deletePdf(index),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
