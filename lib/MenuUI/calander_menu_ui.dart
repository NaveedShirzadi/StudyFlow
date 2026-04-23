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
        MaterialPageRoute(
          builder: (context) => const LinkedAccountsMenuUi(),
        ),
      );
    }
  }

  void _generateSchedule() {
    // Add schedule-generation logic later
  }

  void _openAiAssistant() {
    // Add AI assistant logic later
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
                child: SizedBox(
                  width: menuWidth,
                  child: Text('Groups'),
                ),
              ),
              const PopupMenuItem(
                value: 'Friends',
                child: SizedBox(
                  width: menuWidth,
                  child: Text('Friends'),
                ),
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
                child: SizedBox(
                  width: menuWidth,
                  child: Text('Study Mode'),
                ),
              ),
              const PopupMenuItem(
                value: 'Settings',
                child: SizedBox(
                  width: menuWidth,
                  child: Text('Settings'),
                ),
              ),
              const PopupMenuItem(
                value: 'Sign Out',
                child: SizedBox(
                  width: menuWidth,
                  child: Text('Sign Out'),
                ),
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

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarMenuUi(),
    ),
  );
}