import 'package:flutter/material.dart';
import 'theme_manager.dart'; 

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
    return DateTime(_anchorMonth.year, _anchorMonth.month + (page - _initialPage), 1);
  }

  void _goToPreviousMonth() => _pageController.previousPage(duration: const Duration(milliseconds: 220), curve: Curves.easeInOut);
  void _goToNextMonth() => _pageController.nextPage(duration: const Duration(milliseconds: 220), curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.chevron_left, color: ThemeManager.contrastColor), onPressed: _goToPreviousMonth),
              Text(
                '${_monthName(widget.selectedDate.month)} ${widget.selectedDate.year}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ThemeManager.contrastColor),
              ),
              IconButton(icon: Icon(Icons.chevron_right, color: ThemeManager.contrastColor), onPressed: _goToNextMonth),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekdayLabel('M'), _WeekdayLabel('T'), _WeekdayLabel('W'),
              _WeekdayLabel('T'), _WeekdayLabel('F'), _WeekdayLabel('S'), _WeekdayLabel('S'),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => widget.onMonthChanged(_monthForPage(page)),
            itemBuilder: (context, page) {
              return _MonthGrid(
                month: _monthForPage(page),
                selectedDate: widget.selectedDate,
                onDateSelected: widget.onDateSelected,
              );
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const List<String> names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month - 1];
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _MonthGrid({required this.month, required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final leadingDays = (firstDayOfMonth.weekday - 1);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final day = firstDayOfMonth.add(Duration(days: index - leadingDays));
        final isCurrentMonth = day.month == month.month;
        final isSelected = day.year == selectedDate.year && day.month == selectedDate.month && day.day == selectedDate.day;

        return GestureDetector(
          onTap: () => onDateSelected(day),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 47, 158, 249)
                  : isCurrentMonth
                      ? ThemeManager.contrastColor.withOpacity(0.1)
                      : ThemeManager.contrastColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : isCurrentMonth ? ThemeManager.contrastColor : ThemeManager.contrastColor.withOpacity(0.4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;
  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: ThemeManager.contrastColor.withOpacity(0.6), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}