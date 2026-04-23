import 'package:flutter/material.dart';

class DayCalendarView extends StatefulWidget {
  final DateTime selectedDate;
  final double hourHeight;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onBackToMonth;

  const DayCalendarView({
    super.key,
    required this.selectedDate,
    required this.hourHeight,
    required this.onDateChanged,
    required this.onBackToMonth,
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
              return _SingleDayTimeline(
                date: pageDate,
                hourHeight: widget.hourHeight,
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

  const _SingleDayTimeline({
    required this.date,
    required this.hourHeight,
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
                child: Container(
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