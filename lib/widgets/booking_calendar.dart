import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'neo_box.dart';

class BookingCalendar extends StatelessWidget {
  const BookingCalendar({
    super.key,
    required this.month,
    required this.selected,
    required this.onSelect,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime month;
  final DateTime? selected;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback? onPrevMonth; // null = tombol nonaktif
  final VoidCallback? onNextMonth;

  static const _weekdays = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];

  @override
  Widget build(BuildContext context) {
    final offset = DateTime(month.year, month.month, 1).weekday - 1;
    final days = DateTime(month.year, month.month + 1, 0).day;

    final cells = <Widget>[
      for (int i = 0; i < offset; i++) const SizedBox.shrink(),
      for (int d = 1; d <= days; d++) _cell(DateTime(month.year, month.month, d)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NeoBox(
          color: AppColors.mint,
          shadowOffset: 3,
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _arrow(Icons.arrow_back, onPrevMonth),
              Text(
                '${kMonthNames[month.month - 1].toUpperCase()} ${month.year}',
                style: AppText.label(15),
              ),
              _arrow(Icons.arrow_forward, onNextMonth),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (int i = 0; i < 7; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    border: Border.all(color: AppColors.black, width: 2),
                  ),
                  child: Text(
                    _weekdays[i],
                    style: AppText.label(
                      10,
                      color: i == 5
                          ? AppColors.royal
                          : i == 6
                              ? AppColors.red
                              : AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: cells,
        ),
      ],
    );
  }

  Widget _arrow(IconData icon, VoidCallback? onTap) {
    return Opacity(
      opacity: onTap == null ? 0.3 : 1,
      child: MouseRegion(
        cursor: onTap == null
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.black, width: 2),
            ),
            child: Icon(icon, size: 16),
          ),
        ),
      ),
    );
  }

  Widget _cell(DateTime date) {
    final disabled = date.isBefore(kToday);
    final isSel = selected != null && isSameDay(selected!, date);

    final textColor = isSel
        ? Colors.white
        : disabled
            ? Colors.black38
            : AppColors.black;

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: disabled ? null : () => onSelect(date),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSel
                ? AppColors.royal
                : disabled
                    ? AppColors.grey
                    : Colors.white,
            border: Border.all(
              color: disabled ? Colors.black26 : AppColors.black,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${date.day}',
                style: AppText.label(13, color: textColor).copyWith(
                  decoration:
                      disabled ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              if (isSel)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}