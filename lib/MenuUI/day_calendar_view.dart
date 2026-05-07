import 'package:flutter/material.dart';
import 'theme_manager.dart';

class DayCalendarView extends StatefulWidget {
  final DateTime selectedDate;
  final double hourHeight;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onBackToMonth;
  final ValueNotifier<Map<String, List<Map<String, String>>>> eventsNotifier;

  const DayCalendarView({
    super.key,
    required this.selectedDate,
    required this.hourHeight,
    required this.onDateChanged,
    required this.onBackToMonth,
    required this.eventsNotifier,
  });

  @override
  State<DayCalendarView> createState() => _DayCalendarViewState();
}

class _DayCalendarViewState extends State<DayCalendarView> {
  static const int _initialPage = 5000;
  late final PageController _pageController;
  late DateTime _anchorDate;

  @override
  void initState() {
    super.initState();
    _anchorDate = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );
    _pageController = PageController(initialPage: _initialPage);
  }

  void _handlePageChanged(int page) {
    final DateTime nextDate = _anchorDate.add(
      Duration(days: page - _initialPage),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onDateChanged(nextDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = ThemeManager.contrastColor;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: widget.onBackToMonth,
                icon: Icon(Icons.calendar_view_month, color: textColor),
                label: Text(
                  'Back to month',
                  style: TextStyle(color: textColor),
                ),
              ),
              const Spacer(),
              Text(
                _formattedDate(widget.selectedDate),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _handlePageChanged,
            itemBuilder: (context, page) {
              final DateTime pageDate = _anchorDate.add(
                Duration(days: page - _initialPage),
              );
              return _SingleDayTimeline(
                date: pageDate,
                hourHeight: widget.hourHeight,
                eventsNotifier: widget.eventsNotifier,
                contrastColor: textColor,
              );
            },
          ),
        ),
      ],
    );
  }

  String _formattedDate(DateTime date) {
    const List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _SingleDayTimeline extends StatefulWidget {
  final DateTime date;
  final double hourHeight;
  final ValueNotifier<Map<String, List<Map<String, String>>>> eventsNotifier;
  final Color contrastColor;

  const _SingleDayTimeline({
    required this.date,
    required this.hourHeight,
    required this.eventsNotifier,
    required this.contrastColor,
  });

  @override
  State<_SingleDayTimeline> createState() => _SingleDayTimelineState();
}

class _SingleDayTimelineState extends State<_SingleDayTimeline> {
  @override
  void initState() {
    super.initState();
    widget.eventsNotifier.addListener(_onEventsChanged);
  }

  @override
  void dispose() {
    widget.eventsNotifier.removeListener(_onEventsChanged);
    super.dispose();
  }

  void _onEventsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String dateKey = '${widget.date.year}-${widget.date.month}-${widget.date.day}';
    List<Map<String, String>> events = widget.eventsNotifier.value[dateKey] ?? [];

    return ListView.builder(
      key: ValueKey('${widget.date.year}-${widget.date.month}-${widget.date.day}'),
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
      itemCount: 24,
      itemBuilder: (context, index) {
        return SizedBox(
          height: widget.hourHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatHour(index),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // FIXED: withOpacity -> withValues
                      color: widget.contrastColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            // FIXED: withOpacity -> withValues
                            color: widget.contrastColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    ...events
                        .where((e) {
                          int eventHour = int.tryParse(e['startHour'] ?? '') ?? -1;
                          return eventHour == index;
                        })
                        .map((e) {
                          double startMinuteFraction = (int.tryParse(e['startMinute'] ?? '0') ?? 0) / 60;
                          double durationHours = (double.tryParse(e['durationMinutes'] ?? '0') ?? 0) / 60;
                          bool isBreak = (e['title'] ?? '').toLowerCase().contains('break');
                          
                          return Positioned(
                            top: startMinuteFraction * widget.hourHeight,
                            left: 0,
                            right: 0,
                            height: (durationHours * widget.hourHeight).clamp(20, widget.hourHeight * 3),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isBreak ? const Color.fromARGB(255, 255, 171, 64) : const Color.fromARGB(255, 47, 158, 249),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                e['title'] ?? '',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        })
                        ,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatHour(int hour) {
    final int displayHour = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
    final String suffix = hour < 12 ? 'AM' : 'PM';
    return '$displayHour:00 $suffix';
  }
}