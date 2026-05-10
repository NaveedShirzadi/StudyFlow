import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'calendar_view_shell.dart';
import 'linked_accounts_menu_ui.dart';
import 'setting_ui.dart';
import '../study_mode/study_mode_page.dart';
import 'theme_manager.dart';

final ValueNotifier<Map<String, List<Map<String, String>>>>
calendarEventsNotifier = ValueNotifier({});

Color _contrastFor(Color color) {
  return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

Color _themedSurfaceColor(ThemeColors theme) {
  final Color base = theme.secondary.computeLuminance() > 0.5
      ? Colors.white
      : const Color(0xFF121212);

  return Color.alphaBlend(theme.secondary.withValues(alpha: 0.16), base);
}

Color _softTint(Color tint, Color surface, double alpha) {
  return Color.alphaBlend(tint.withValues(alpha: alpha), surface);
}

InputDecoration _themedInputDecoration({
  required String hintText,
  required Color onSurface,
  required Color primaryColor,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: onSurface.withValues(alpha: 0.28)),
  );

  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.58)),
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    border: border,
  );
}

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
    } else if (value == 'Study Mode') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudyModePage()),
      );
    }
  }

  void _generateSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ScheduleGeneratorSheet(),
    );
  }

  void _openAiAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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

    return ValueListenableBuilder<ThemeColors>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, theme, _) {
        final Color contrast = ThemeManager.contrastColor;
        final Color menuSurface = _themedSurfaceColor(theme);
        final Color menuTextColor = _contrastFor(menuSurface);

        final Color bottomBarColor = contrast == Colors.black
            ? const Color.fromARGB(230, 255, 255, 255)
            : const Color.fromARGB(224, 0, 0, 0);

        final Color bottomButtonColor = contrast.withValues(
          alpha: contrast == Colors.black ? 0.08 : 0.14,
        );

        PopupMenuItem<String> menuItem(String value, String label) {
          return PopupMenuItem(
            value: value,
            child: SizedBox(
              width: menuWidth,
              child: Text(label, style: TextStyle(color: menuTextColor)),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primary, theme.secondary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: contrast),
                onPressed: _handleBackPressed,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: contrast),
              actions: [
                PopupMenuButton<String>(
                  color: menuSurface,
                  icon: Icon(Icons.more_vert, color: contrast),
                  onSelected: _handleMenuSelection,
                  itemBuilder: (BuildContext context) => [
                    menuItem('Linked Accounts', 'Linked Accounts'),
                    menuItem('Study Mode', 'Study Mode'),
                    menuItem('Settings', 'Settings'),
                    menuItem('Sign Out', 'Sign Out'),
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
                            color: bottomBarColor,
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
                                      backgroundColor: bottomButtonColor,
                                      foregroundColor: contrast,
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
                                decoration: BoxDecoration(
                                  color: bottomButtonColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: _openAiAssistant,
                                  icon: Icon(Icons.smart_toy, color: contrast),
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
          ),
        );
      },
    );
  }
}

Future<String> callGroq(String prompt) async {
  String apiKey = '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';

  var response = await http.post(
    Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
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
  final TextEditingController subjectsController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController daysController = TextEditingController();

  String result = '';
  bool isLoading = false;
  DateTime selectedStartDate = DateTime.now();

  @override
  void dispose() {
    subjectsController.dispose();
    hoursController.dispose();
    daysController.dispose();
    super.dispose();
  }

  Future<void> handleGenerate() async {
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
        'Format it day by day with time blocks '
        '(e.g., Day 1: 09:00 AM - 10:00 AM: Subject) '
        'and include short breaks.';

    setState(() => isLoading = true);

    try {
      String response = await callGroq(prompt);

      if (!mounted) return;

      setState(() => result = response);
      _parseAndStoreEvents(response, days, selectedStartDate);
    } catch (e) {
      if (!mounted) return;

      setState(() => result = 'Something went wrong: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _parseAndStoreEvents(String schedule, int days, DateTime startDate) {
    calendarEventsNotifier.value = {};

    RegExp dayRegex = RegExp(r'Day (\d+):');
    RegExp timeRegex = RegExp(
      r'(\d+):(\d+)\s*(AM|PM)\s*-\s*(\d+):(\d+)\s*(AM|PM)\s*[:\-]\s*(.+)',
    );

    List<String> lines = schedule.split('\n');
    int currentDay = 0;
    Map<String, List<Map<String, String>>> updated = {};

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

        updated.putIfAbsent(dateKey, () => []);
        updated[dateKey]!.add({
          'title': title,
          'startHour': startHour.toString(),
          'startMinute': startMinute.toString(),
          'durationMinutes': durationMinutes.toString(),
        });
      }
    }

    calendarEventsNotifier.value = updated;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeColors>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, theme, _) {
        final Color surface = _themedSurfaceColor(theme);
        final Color onSurface = _contrastFor(surface);
        final Color buttonTextColor = _contrastFor(theme.primary);

        return Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: onSurface),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Generate Study Schedule',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: subjectsController,
                    style: TextStyle(color: onSurface),
                    decoration: _themedInputDecoration(
                      hintText: 'Subjects (e.g. Math, History, Biology)',
                      onSurface: onSurface,
                      primaryColor: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hoursController,
                    style: TextStyle(color: onSurface),
                    keyboardType: TextInputType.number,
                    decoration: _themedInputDecoration(
                      hintText: 'Hours available per day (e.g. 4)',
                      onSurface: onSurface,
                      primaryColor: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: daysController,
                    style: TextStyle(color: onSurface),
                    keyboardType: TextInputType.number,
                    decoration: _themedInputDecoration(
                      hintText: 'Number of days (e.g. 5)',
                      onSurface: onSurface,
                      primaryColor: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Start Date',
                      style: TextStyle(color: onSurface),
                    ),
                    subtitle: Text(
                      '${selectedStartDate.month}/${selectedStartDate.day}/${selectedStartDate.year}',
                      style: TextStyle(color: onSurface.withValues(alpha: 0.7)),
                    ),
                    trailing: Icon(Icons.calendar_today, color: theme.primary),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedStartDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.fromSeed(
                                seedColor: theme.primary,
                                brightness: surface.computeLuminance() > 0.5
                                    ? Brightness.light
                                    : Brightness.dark,
                              ),
                            ),
                            child: child ?? const SizedBox.shrink(),
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() => selectedStartDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleGenerate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: buttonTextColor,
                        disabledBackgroundColor: theme.primary.withValues(
                          alpha: 0.45,
                        ),
                        disabledForegroundColor: buttonTextColor.withValues(
                          alpha: 0.7,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: buttonTextColor,
                              ),
                            )
                          : const Text('Generate'),
                    ),
                  ),
                  if (result.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _softTint(theme.primary, surface, 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        result,
                        style: TextStyle(fontSize: 14, color: onSurface),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AiAssistantSheet extends StatefulWidget {
  const AiAssistantSheet({super.key});

  @override
  State<AiAssistantSheet> createState() => AiAssistantSheetState();
}

class AiAssistantSheetState extends State<AiAssistantSheet> {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [];

  bool isLoading = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> handleSend() async {
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

      if (!mounted) return;

      setState(() => messages.add({'role': 'ai', 'text': response}));
    } catch (e) {
      if (!mounted) return;

      setState(
        () => messages.add({'role': 'ai', 'text': 'Something went wrong: $e'}),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeColors>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, theme, _) {
        final Color surface = _themedSurfaceColor(theme);
        final Color onSurface = _contrastFor(surface);
        final Color userBubbleText = _contrastFor(theme.primary);
        final Color aiBubbleColor = _softTint(theme.secondary, surface, 0.22);

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            children: [
              Text(
                'AI Study Assistant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
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
                          color: isUser ? theme.primary : aiBubbleColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message['text'] ?? '',
                          style: TextStyle(
                            color: isUser ? userBubbleText : onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading)
                LinearProgressIndicator(
                  color: theme.primary,
                  backgroundColor: onSurface.withValues(alpha: 0.12),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(color: onSurface),
                      decoration:
                          _themedInputDecoration(
                            hintText: 'Ask me anything about studying...',
                            onSurface: onSurface,
                            primaryColor: theme.primary,
                          ).copyWith(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: onSurface.withValues(alpha: 0.28),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: theme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: isLoading ? null : handleSend,
                    icon: const Icon(Icons.send),
                    color: theme.primary,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
