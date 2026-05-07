import 'package:flutter/material.dart';

class DayCalendarView extends StatefulWidget {
  final DateTime selectedDate;
  final double hourHeight;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onBackToMonth;
  final Map<String, List<Map<String, String>>> events;

  const DayCalendarView({
    super.key,
    required this.selectedDate,
    required this.hourHeight,
    required this.onDateChanged,
    required this.onBackToMonth,
    required this.events,
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

  DateTime _dateForPage(int page) {
    final int offset = page - _initialPage;
    return _anchorDate.add(Duration(days: offset));
  }

  void _handlePageChanged(int page) {
    final DateTime nextDate = _dateForPage(page);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onDateChanged(nextDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: widget.onBackToMonth,
                icon: const Icon(Icons.calendar_view_month),
                label: const Text('Back to month'),
              ),
              const Spacer(),
              Text(
                _formattedDate(widget.selectedDate),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
              final DateTime pageDate = _dateForPage(page);
              String dateKey =
                  '${pageDate.year}-${pageDate.month}-${pageDate.day}';
              return _SingleDayTimeline(
                date: pageDate,
                hourHeight: widget.hourHeight,
                events: widget.events[dateKey] ?? [],
              );
            },
          ),
        ),
      ],
    );
  }

  String _formattedDate(DateTime date) {
    const List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _SingleDayTimeline extends StatelessWidget {
  final DateTime date;
  final double hourHeight;
  final List<Map<String, String>> events;

  const _SingleDayTimeline({
    required this.date,
    required this.hourHeight,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: ValueKey('${date.year}-${date.month}-${date.day}'),
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
      itemCount: 24,
      itemBuilder: (context, index) {
        return SizedBox(
          height: hourHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatHour(index),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
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
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    ...events
                        .where((e) {
                          int eventHour =
                              int.tryParse(e['startHour'] ?? '') ?? -1;
                          return eventHour == index;
                        })
                        .map((e) {
                          double startMinuteFraction =
                              (int.tryParse(e['startMinute'] ?? '0') ?? 0) / 60;
                          double durationHours =
                              (double.tryParse(e['durationMinutes'] ?? '0') ??
                                  0) /
                              60;
                          return Positioned(
                            top: startMinuteFraction * hourHeight,
                            left: 0,
                            right: 0,
                            height: (durationHours * hourHeight).clamp(
                              20,
                              hourHeight * 3,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 47, 158, 249),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                e['title'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        })
                        .toList(),
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
    final int displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    final String suffix = hour < 12 ? 'AM' : 'PM';
    return '$displayHour:00 $suffix';
  }
}
