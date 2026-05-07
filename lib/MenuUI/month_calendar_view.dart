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
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (page) => widget.onMonthChanged(_monthForPage(page)),
      itemBuilder: (context, index) {
        final month = _monthForPage(index);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _MonthHeader(
                month: month,
                onPrevious: _goToPreviousMonth,
                onNext: _goToNextMonth,
              ),
              const SizedBox(height: 20),
              const _WeekdayRow(),
              const SizedBox(height: 10),
              Expanded(
                child: _MonthGrid(
                  month: month,
                  selectedDate: widget.selectedDate,
                  onDateSelected: widget.onDateSelected,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthHeader({required this.month, required this.onPrevious, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${months[month.month - 1]} ${month.year}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ThemeManager.contrastColor),
        ),
        Row(
          children: [
            IconButton(onPressed: onPrevious, icon: Icon(Icons.chevron_left, color: ThemeManager.contrastColor)),
            IconButton(onPressed: onNext, icon: Icon(Icons.chevron_right, color: ThemeManager.contrastColor)),
          ],
        ),
      ],
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();
  @override
  Widget build(BuildContext context) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((d) => _WeekdayLabel(d)).toList(),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _MonthGrid({required this.month, required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday % 7;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, crossAxisSpacing: 8, mainAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final dayOffset = index - startWeekday;
        final day = firstDay.add(Duration(days: dayOffset));
        final isCurrentMonth = day.month == month.month;
        final isSelected = day.year == selectedDate.year && day.month == selectedDate.month && day.day == selectedDate.day;

        return GestureDetector(
          onTap: () => onDateSelected(day),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 47, 158, 249)
                  : isCurrentMonth
                      // FIXED: Lower alpha to 0.05 to prevent the "white overlap" look
                      ? ThemeManager.contrastColor.withValues(alpha: 0.05)
                      : ThemeManager.contrastColor.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : isCurrentMonth ? ThemeManager.contrastColor : ThemeManager.contrastColor.withValues(alpha: 0.4),
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
          style: TextStyle(color: ThemeManager.contrastColor.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}