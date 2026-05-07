import 'package:flutter/material.dart';
import 'setting_ui.dart';
import 'calendar_view_shell.dart';
import 'linked_accounts_menu_ui.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      builder: (context) => const AiAssistantSheet(),
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

Future<String> callGroq(String prompt) async {
  String apiKey = 'api key here';

  var response = await http.post(
    Uri.parse('api link here'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': 'openai/gpt-oss-120b',
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful study assistant for college students.',
        },
        {'role': 'user', 'content': prompt},
      ],
    }),
  );

  if (response.statusCode != 200) {
    return 'API Error ${response.statusCode}: ${response.body}';
  }
  var data = jsonDecode(response.body);
  return data['choices'][0]['message']['content'];
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
      String response = await callGroq(prompt);
      setState(() => result = response);
      _parseAndStoreEvents(response, days);
    } catch (e) {
      setState(() => result = 'Something went wrong: $e');
    }

    setState(() => isLoading = false);
  }

  void _parseAndStoreEvents(String schedule, int days) {
    calendarEvents.clear();
    DateTime startDate = DateTime.now();

    RegExp dayRegex = RegExp(r'Day (\d+):');
    RegExp timeRegex = RegExp(
      r'(\d+):(\d+)\s*(AM|PM)\s*-\s*(\d+):(\d+)\s*(AM|PM)\s*[:\-]\s*(.+)',
    );

    List<String> lines = schedule.split('\n');
    int currentDay = 0;

    for (String line in lines) {
      var dayMatch = dayRegex.firstMatch(line);
      if (dayMatch != null) {
        currentDay = int.tryParse(dayMatch.group(1)!) ?? 0;
        continue;
      }

      var timeMatch = timeRegex.firstMatch(line);
      if (timeMatch != null && currentDay > 0) {
        int startHour = int.tryParse(timeMatch.group(1)!) ?? 0;
        int startMinute = int.tryParse(timeMatch.group(2)!) ?? 0;
        String startSuffix = timeMatch.group(3)!;
        int endHour = int.tryParse(timeMatch.group(4)!) ?? 0;
        int endMinute = int.tryParse(timeMatch.group(5)!) ?? 0;
        String endSuffix = timeMatch.group(6)!;
        String title = timeMatch.group(7)!.trim();

        if (startSuffix == 'PM' && startHour != 12) startHour += 12;
        if (startSuffix == 'AM' && startHour == 12) startHour = 0;
        if (endSuffix == 'PM' && endHour != 12) endHour += 12;
        if (endSuffix == 'AM' && endHour == 12) endHour = 0;

        int durationMinutes =
            (endHour * 60 + endMinute) - (startHour * 60 + startMinute);

        DateTime eventDate = startDate.add(Duration(days: currentDay - 1));
        String dateKey =
            '${eventDate.year}-${eventDate.month}-${eventDate.day}';

        calendarEvents.putIfAbsent(dateKey, () => []);
        calendarEvents[dateKey]!.add({
          'title': title,
          'startHour': startHour.toString(),
          'startMinute': startMinute.toString(),
          'durationMinutes': durationMinutes.toString(),
        });
      }
    }
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

class AiAssistantSheet extends StatefulWidget {
  const AiAssistantSheet();

  @override
  State<AiAssistantSheet> createState() => AiAssistantSheetState();
}

class AiAssistantSheetState extends State<AiAssistantSheet> {
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
      String response = await callGroq(prompt);
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
