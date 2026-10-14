import '../utils/formatters.dart';
import 'studio_package.dart';
import 'time_slot.dart';

class BookingData {
  const BookingData({
    required this.package,
    required this.date,
    required this.slot,
    required this.cleaningFee,
  });

  final StudioPackage package;
  final DateTime date;
  final TimeSlot slot;
  final int cleaningFee;

  int get basePrice => package.price;
  int get subtotal => basePrice + cleaningFee;
  String get dateLabel => formatDateLong(date);
}