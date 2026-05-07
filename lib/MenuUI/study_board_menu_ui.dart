import 'package:flutter/material.dart';
import 'theme_manager.dart';

class StudyBoardMenuUI extends StatefulWidget {
  static const routeName = '/studyBoardMenu';
  const StudyBoardMenuUI({super.key});

  @override
  State<StudyBoardMenuUI> createState() => _StudyBoardMenuUIState();
}

class _StudyBoardMenuUIState extends State<StudyBoardMenuUI> {
  final TextEditingController taskController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  void addTask() {
    String taskName = taskController.text.trim();
    if (taskName.isEmpty) return;
    setState(() => tasks.add({'name': taskName, 'done': false}));
    taskController.clear();
  }

  void toggleTask(int index) => setState(() => tasks[index]['done'] = !tasks[index]['done']);
  void deleteTask(int index) => setState(() => tasks.removeAt(index));

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Board'),
        backgroundColor: Colors.transparent, elevation: 0,
        iconTheme: IconThemeData(color: ThemeManager.contrastColor),
        titleTextStyle: TextStyle(color: ThemeManager.contrastColor, fontSize: 20),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        style: TextStyle(color: ThemeManager.contrastColor),
                        decoration: InputDecoration(
                          hintText: 'Enter a task...',
                          hintStyle: TextStyle(color: ThemeManager.contrastColor.withOpacity(0.6)),
                          filled: true,
                          fillColor: ThemeManager.contrastColor.withOpacity(0.1),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: addTask,
                      style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(16)),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(child: Text('No tasks yet! You\'re all caught up.', style: TextStyle(color: ThemeManager.contrastColor)))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final bool isDone = tasks[index]['done'];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: Checkbox(value: isDone, onChanged: (value) => toggleTask(index)),
                                title: Text(
                                  tasks[index]['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                    color: isDone ? Colors.grey : Colors.black,
                                  ),
                                ),
                                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => deleteTask(index)),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}