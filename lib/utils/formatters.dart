const String kTimeZone = 'WITA';
const String kTimeZoneOffset = 'UTC+8';

const List<String> kDayNames = [
  'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
];
const List<String> kMonthNames = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];
const List<String> kMonthShort = [
  'JAN', 'FEB', 'MAR', 'APR', 'MEI', 'JUN',
  'JUL', 'AGU', 'SEP', 'OKT', 'NOV', 'DES'
];

String formatRupiah(int value) {
  final neg = value < 0;
  final s = value.abs().toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '${neg ? '-' : ''}Rp $buf';
}

String formatDateLong(DateTime d) =>
    '${kDayNames[d.weekday - 1]}, ${d.day} ${kMonthNames[d.month - 1]} ${d.year}';

String formatDateShort(DateTime d) => '${d.day} ${kMonthShort[d.month - 1]}';

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;