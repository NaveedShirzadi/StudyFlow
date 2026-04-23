import 'package:flutter/material.dart';

class MonthCalendarView extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged;

  const MonthCalendarView({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  State<MonthCalendarView> createState() => _MonthCalendarViewState();
}

class _MonthCalendarViewState extends State<MonthCalendarView> {
  static const int _initialPage = 5000;

  late final PageController _pageController;
  late DateTime _anchorMonth;

  @override
  void initState() {
    super.initState();
    _anchorMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
    _pageController = PageController(initialPage: _initialPage);
  }

  DateTime _monthForPage(int page) {
    final int offset = page - _initialPage;
    return DateTime(_anchorMonth.year, _anchorMonth.month + offset, 1);
  }

  void _goToPreviousMonth() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextMonth() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  void _handlePageChanged(int page) {
    final DateTime month = _monthForPage(page);
    final int safeDay = widget.selectedDate.day.clamp(
      1,
      DateUtils.getDaysInMonth(month.year, month.month),
    );

    final DateTime nextSelectedDate = DateTime(month.year, month.month, safeDay);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onMonthChanged(nextSelectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _handlePageChanged,
      itemBuilder: (context, page) {
        final DateTime month = _monthForPage(page);

        return _MonthGridPage(
          month: month,
          selectedDate: widget.selectedDate,
          onDateSelected: widget.onDateSelected,
          onPreviousMonth: _goToPreviousMonth,
          onNextMonth: _goToNextMonth,
        );
      },
    );
  }
}

class _MonthGridPage extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _MonthGridPage({
    required this.month,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  DateTime _firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime _gridStartDate(DateTime date) {
    final DateTime first = _firstDayOfMonth(date);
    final int weekdayOffset = first.weekday % 7;
    return first.subtract(Duration(days: weekdayOffset));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime firstOfMonth = _firstDayOfMonth(month);
    final DateTime startDate = _gridStartDate(month);
    const List<String> weekdayLabels = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onPreviousMonth,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Previous month',
                ),
                Text(
                  '${_monthName(firstOfMonth.month)} ${firstOfMonth.year}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onNextMonth,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next month',
                ),
              ],
            ),
          ),
          Row(
            children: weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          label,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: 42,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final DateTime day = startDate.add(Duration(days: index));
                final bool isSelected =
                    day.year == selectedDate.year &&
                    day.month == selectedDate.month &&
                    day.day == selectedDate.day;
                final bool isCurrentMonth = day.month == firstOfMonth.month;

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onDateSelected(day),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : isCurrentMonth
                              ? const Color.fromARGB(20, 0, 0, 0)
                              : const Color.fromARGB(10, 0, 0, 0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : isCurrentMonth
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const List<String> names = [
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
    return names[month - 1];
  }
}