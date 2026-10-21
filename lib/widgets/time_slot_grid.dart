import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'neo_tag.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({
    super.key,
    required this.date,
    required this.selectedIndex,
    required this.onSelect,
  });

  final DateTime date;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final booked = bookedSlotIndexes(date);

    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 10) / 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (int i = 0; i < kTimeSlots.length; i++)
            SizedBox(width: w, child: _slot(i, booked.contains(i))),
        ],
      );
    });
  }

  Widget _slot(int i, bool isBooked) {
    final slot = kTimeSlots[i];
    final isSel = selectedIndex == i && !isBooked;

    final Widget indicator;
    if (isBooked) {
      indicator = const NeoTag(
          text: 'TERISI',
          color: AppColors.black,
          textColor: Colors.white,
          fontSize: 9);
    } else if (isSel) {
      indicator = const NeoTag(
          text: '★ DIPILIH',
          color: AppColors.black,
          textColor: Colors.white,
          fontSize: 9);
    } else {
      indicator = Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.black, width: 2),
        ),
      );
    }

    final subtitle = isBooked
        ? slot.bookedLabel
        : '${slot.period} / READY';

    return MouseRegion(
      cursor: isBooked ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isBooked ? null : () => onSelect(i),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isBooked
                ? const Color(0xFFDDDDDD)
                : isSel
                    ? AppColors.mint
                    : Colors.white,
            border: Border.all(color: AppColors.black, width: 3),
            boxShadow: isBooked
                ? null
                : const [
                    BoxShadow(
                        color: AppColors.black,
                        offset: Offset(3, 3),
                        blurRadius: 0)
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slot.time,
                style: AppText.label(13,
                        color: isBooked ? Colors.black45 : AppColors.black)
                    .copyWith(
                  decoration:
                      isBooked ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(subtitle,
                        style: AppText.label(9, color: Colors.black54)),
                  ),
                  indicator,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}