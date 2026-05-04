import 'package:flutter/material.dart';
import 'setting_ui.dart';
import 'calendar_view_shell.dart';
import 'linked_accounts_menu_ui.dart';

class CalendarMenuUi extends StatelessWidget {
  const CalendarMenuUi({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalendarMenuPage();
  }
}

class CalendarMenuPage extends StatefulWidget {
  const CalendarMenuPage({super.key});

  @override
  State<CalendarMenuPage> createState() => _CalendarMenuPageState();
}

class _CalendarMenuPageState extends State<CalendarMenuPage> {
  final GlobalKey<CalendarViewShellState> _calendarShellKey =
      GlobalKey<CalendarViewShellState>();

  void _handleMenuSelection(String value) {
    if (value == 'Settings') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsPage(title: 'Settings'),
        ),
      );
    } else if (value == 'Linked Accounts') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LinkedAccountsMenuUi()),
      );
    }
  }

  void _generateSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _ScheduleGeneratorSheet(),
    );
  }

  void _openAiAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _AiAssistantSheet(),
    );
  }

  void _handleBackPressed() {
    final shellState = _calendarShellKey.currentState;

    if (shellState != null && shellState.isInDayView) {
      shellState.goToMonthView();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double menuWidth = 140;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackPressed,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'Groups',
                child: SizedBox(width: menuWidth, child: Text('Groups')),
              ),
              const PopupMenuItem(
                value: 'Friends',
                child: SizedBox(width: menuWidth, child: Text('Friends')),
              ),
              const PopupMenuItem(
                value: 'Linked Accounts',
                child: SizedBox(
                  width: menuWidth,
                  child: Text('Linked Accounts'),
                ),
              ),
              const PopupMenuItem(
                value: 'Study Mode',
                child: SizedBox(width: menuWidth, child: Text('Study Mode')),
              ),
              const PopupMenuItem(
                value: 'Settings',
                child: SizedBox(width: menuWidth, child: Text('Settings')),
              ),
              const PopupMenuItem(
                value: 'Sign Out',
                child: SizedBox(width: menuWidth, child: Text('Sign Out')),
              ),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          CalendarViewShell(key: _calendarShellKey),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(224, 0, 0, 0),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(66, 0, 0, 0),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: _generateSchedule,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  36,
                                  255,
                                  255,
                                  255,
                                ),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Generate Schedule',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(26, 255, 255, 255),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _openAiAssistant,
                            icon: const Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                            ),
                            tooltip: 'AI Assistant',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> callClaude(String prompt) async {
  await Future.delayed(const Duration(seconds: 2));

  if (prompt.contains('study schedule')) {
    int days = 5;
    int hoursPerDay = 4;
    List<String> subjects = [];

    RegExp daysRegex = RegExp(r'Number of days: (\d+)');
    RegExp hoursRegex = RegExp(r'Hours per day: (\d+)');
    RegExp subjectsRegex = RegExp(r'Subjects: (.+?)\.');

    var daysMatch = daysRegex.firstMatch(prompt);
    var hoursMatch = hoursRegex.firstMatch(prompt);
    var subjectsMatch = subjectsRegex.firstMatch(prompt);

    if (daysMatch != null) days = int.tryParse(daysMatch.group(1)!) ?? 5;
    if (hoursMatch != null)
      hoursPerDay = int.tryParse(hoursMatch.group(1)!) ?? 4;
    if (subjectsMatch != null) {
      subjects = subjectsMatch
          .group(1)!
          .split(',')
          .map((s) => s.trim())
          .toList();
    }

    if (subjects.isEmpty) return 'Please enter at least one subject.';

    int totalMinutes = hoursPerDay * 60;
    int breakTotalMinutes = (subjects.length - 1) * 15;
    int studyMinutes = totalMinutes - breakTotalMinutes;
    int minutesPerSubject = (studyMinutes / subjects.length).floor();

    String schedule = '';

    for (int i = 1; i <= days; i++) {
      schedule += 'Day $i:\n';

      List<String> rotated = [
        ...subjects.sublist(i % subjects.length),
        ...subjects.sublist(0, i % subjects.length),
      ];

      int currentHour = 9;
      int currentMinute = 0;

      for (int j = 0; j < rotated.length; j++) {
        String start = _formatTime(currentHour, currentMinute);

        int endMinute = currentMinute + minutesPerSubject;
        int endHour = currentHour + (endMinute ~/ 60);
        endMinute = endMinute % 60;
        String end = _formatTime(endHour, endMinute);

        schedule += '$start - $end: ${rotated[j]}\n';

        if (j < rotated.length - 1) {
          String breakStart = _formatTime(endHour, endMinute);
          int breakEndMinute = endMinute + 15;
          int breakEndHour = endHour + (breakEndMinute ~/ 60);
          breakEndMinute = breakEndMinute % 60;
          schedule +=
              '$breakStart - ${_formatTime(breakEndHour, breakEndMinute)}: Break\n';
          currentHour = breakEndHour;
          currentMinute = breakEndMinute;
        }
      }

      schedule += '\n';
    }

    schedule += 'Study Tips:\n';
    for (String subject in subjects) {
      schedule += '- $subject: review notes and do practice problems daily\n';
    }
    schedule += '- Take short breaks between subjects\n';
    schedule += '- Stay hydrated and get enough sleep\n';

    return schedule;
  }

  return 'Great question! Here are some tips to help you study more effectively: '
      'break your material into smaller chunks, use active recall instead of '
      'just rereading, and make sure to take regular breaks.';
}

String _formatTime(int hour, int minute) {
  String suffix = hour < 12 ? 'AM' : 'PM';
  int displayHour = hour == 0
      ? 12
      : hour > 12
      ? hour - 12
      : hour;
  String displayMinute = minute.toString().padLeft(2, '0');
  return '$displayHour:$displayMinute $suffix';
}

class _ScheduleGeneratorSheet extends StatefulWidget {
  const _ScheduleGeneratorSheet();

  @override
  State<_ScheduleGeneratorSheet> createState() =>
      _ScheduleGeneratorSheetState();
}

class _ScheduleGeneratorSheetState extends State<_ScheduleGeneratorSheet> {
  TextEditingController subjectsController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  String result = '';
  bool isLoading = false;

  void handleGenerate() async {
    List<String> subjects = subjectsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (subjects.isEmpty) return;

    int hours = int.tryParse(hoursController.text) ?? 4;
    int days = int.tryParse(daysController.text) ?? 5;

    String prompt =
        'Create a detailed study schedule for a student. '
        'Subjects: ${subjects.join(', ')}. '
        'Hours per day: $hours. '
        'Number of days: $days. '
        'Format it day by day with time blocks and include short breaks.';

    setState(() => isLoading = true);

    try {
      String response = await callClaude(prompt);
      setState(() => result = response);
    } catch (e) {
      setState(() => result = 'Something went wrong: $e');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Generate Study Schedule',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subjectsController,
              decoration: InputDecoration(
                hintText: 'Subjects (e.g. Math, History, Biology)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Hours available per day (e.g. 4)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Number of days (e.g. 5)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleGenerate,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Generate'),
              ),
            ),
            if (result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(result, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AiAssistantSheet extends StatefulWidget {
  const _AiAssistantSheet();

  @override
  State<_AiAssistantSheet> createState() => _AiAssistantSheetState();
}

class _AiAssistantSheetState extends State<_AiAssistantSheet> {
  TextEditingController messageController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  void handleSend() async {
    String userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': userMessage});
      isLoading = true;
    });

    messageController.clear();

    String prompt =
        'You are a helpful study assistant. The student says: $userMessage';

    try {
      String response = await callClaude(prompt);
      setState(() => messages.add({'role': 'ai', 'text': response}));
    } catch (e) {
      setState(
        () => messages.add({'role': 'ai', 'text': 'Something went wrong: $e'}),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            const Text(
              'AI Study Assistant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  bool isUser = message['role'] == 'user';
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color.fromARGB(255, 47, 158, 249)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything about studying...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: isLoading ? null : handleSend,
                  icon: const Icon(Icons.send),
                  color: const Color.fromARGB(255, 47, 158, 249),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarMenuUi(),
    ),
  );
}
