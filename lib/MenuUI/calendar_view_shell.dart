import 'package:flutter/material.dart';
import 'month_calendar_view.dart';
import 'day_calendar_view.dart';
import 'theme_manager.dart';

ValueNotifier<Map<String, List<Map<String, String>>>> calendarEventsNotifier =
    ValueNotifier({});

Map<String, List<Map<String, String>>> get calendarEvents =>
    calendarEventsNotifier.value;

enum CalendarDisplayMode { month, day }

class CalendarViewShell extends StatefulWidget {
  const CalendarViewShell({super.key});

  @override
  State<CalendarViewShell> createState() => CalendarViewShellState();
}

class CalendarViewShellState extends State<CalendarViewShell> {
  CalendarDisplayMode _mode = CalendarDisplayMode.month;
  DateTime _selectedDate = DateTime.now();
  double _hourHeight = 80;

  @override
  void initState() {
    super.initState();
    calendarEventsNotifier.addListener(_onEventsChanged);
  }

  @override
  void dispose() {
    calendarEventsNotifier.removeListener(_onEventsChanged);
    super.dispose();
  }

  void _onEventsChanged() {
    setState(() {});
  }

  bool get isInDayView => _mode == CalendarDisplayMode.day;

  void goToMonthView() => setState(() => _mode = CalendarDisplayMode.month);
  void _switchToDay(DateTime date) => setState(() { _selectedDate = date; _mode = CalendarDisplayMode.day; });
  void _changeSelectedDate(DateTime date) => setState(() => _selectedDate = date);
  void _zoomIn() => setState(() => _hourHeight = (_hourHeight + 20).clamp(60, 180));
  void _zoomOut() => setState(() => _hourHeight = (_hourHeight - 20).clamp(40, 180));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_mode == CalendarDisplayMode.day)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _zoomOut, icon: Icon(Icons.remove, color: ThemeManager.contrastColor), tooltip: 'Zoom out',
                ),
                IconButton(
                  onPressed: _zoomIn, icon: Icon(Icons.add, color: ThemeManager.contrastColor), tooltip: 'Zoom in',
                ),
              ],
            ),
          ),
        Expanded(
          child: _mode == CalendarDisplayMode.month
              ? MonthCalendarView(
                  selectedDate: _selectedDate,
                  onDateSelected: _switchToDay,
                  onMonthChanged: _changeSelectedDate,
                )
              : DayCalendarView(
                  selectedDate: _selectedDate,
                  hourHeight: _hourHeight,
                  onDateChanged: _changeSelectedDate,
                  onBackToMonth: goToMonthView,
                  eventsNotifier: calendarEventsNotifier,
                ),
        ),
      ],
    );
  }
}
