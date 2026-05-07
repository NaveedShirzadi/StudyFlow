import 'package:flutter/material.dart';
import 'setting_ui.dart';
import 'calendar_view_shell.dart';
import 'linked_accounts_menu_ui.dart';
import 'theme_manager.dart';
import 'login_page_ui.dart'; // Added for Sign Out navigation

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
  final GlobalKey<CalendarViewShellState> _calendarShellKey = GlobalKey<CalendarViewShellState>();

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?', style: TextStyle(color: Colors.red)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false),
            child: const Text('Yes, Sign Out'),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) async {
    if (value == 'Settings') {
      // Await the pop, then refresh the UI so text contrast updates immediately
      await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(title: 'Settings')));
      setState(() {}); 
    } else if (value == 'Linked Accounts') {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => const LinkedAccountsMenuUi()));
      setState(() {});
    } else if (value == 'Sign Out') {
      _showSignOutDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeManager.contrastColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Schedule', style: TextStyle(color: ThemeManager.contrastColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: ThemeManager.contrastColor),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(value: 'Settings', child: Text('Settings')),
                PopupMenuItem<String>(value: 'Linked Accounts', child: Text('Linked Accounts')),
                // Added Sign Out option to dropdown
                PopupMenuItem<String>(value: 'Sign Out', child: Text('Sign Out', style: TextStyle(color: Colors.red))),
              ];
            },
          ),
        ],
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: ThemeManager.contrastColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CalendarViewShell(key: _calendarShellKey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {}, 
                          icon: const Icon(Icons.calendar_today, size: 20),
                          label: const Text('Generate Schedule'),
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      heroTag: 'calendar_ai_fab',
                      onPressed: () {}, 
                      child: const Icon(Icons.smart_toy),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}