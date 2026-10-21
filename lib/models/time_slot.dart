class TimeSlot {
  const TimeSlot({
    required this.time,
    required this.period,
    this.bookedLabel = 'COMMERCIAL SHOOT',
  });

  final String time; // contoh: '09:00 - 11:00'
  final String period; // PAGI / SIANG / SORE / MALAM
  final String bookedLabel;

  int get hours => 2;
}