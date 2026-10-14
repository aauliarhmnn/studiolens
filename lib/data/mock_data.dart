import 'package:flutter/material.dart';
import '../models/studio_package.dart';
import '../models/time_slot.dart';
import '../theme/app_theme.dart';

/// "Hari ini" dikunci agar demo kalender Oktober 2026 tetap konsisten.
final DateTime kToday = DateTime(2026, 10, 10);

const int kCleaningFee = 25000;

/// Kode promo demo: kode -> potongan harga (Rp).
const Map<String, int> kPromoCodes = {'NEUBRUTAL20': 50000};

const List<StudioPackage> kPackages = [
  StudioPackage(
    id: 'group',
    title: 'GROUP',
    category: 'PROFESIONAL STUDIO',
    badge: 'POPULAR',
    badgeColor: AppColors.blue,
    price: 550000,
    image: 'assets/images/group.JPG',
    features: [
      '5 LEMBAR PHOTO 5R',
      '3-5 ORANG',
      '15 PHOTO EDIT',
      'PHOTO 5R PER ORANG',
      'ALL SOFTFILE',
    ],
  ),
  StudioPackage(
    id: 'prewed',
    title: 'PREWED/POSWED',
    category: 'PROFESIONAL STUDIO',
    badge: 'TOP',
    badgeColor: AppColors.salmon,
    price: 400000,
    image: 'assets/images/prewed.jpg',
    features: [
      '1 KOSTUM',
      '30 MENIT PHOTO SESSION',
      '1 BACKGROUND',
      '15 PHOTO EDIT',
      '5 LEMBAR PHOTO 5R',
      'ALL SOFT FILE',
    ],
  ),
  StudioPackage(
    id: 'basic',
    title: 'BASIC',
    category: 'GRADUATION',
    badge: 'BEST',
    badgeColor: AppColors.purple,
    price: 350000,
    image: 'assets/images/basic.jpg',
    features: [
      '4X SHURE SM7B',
      'BLACKMAGIC ATEM',
      'RGB TUBE LIGHTING',
      'SOUND ENGINEER INC.',
    ],
  ),
];

const List<TimeSlot> kTimeSlots = [
  TimeSlot(time: '09:00 - 11:00', period: 'PAGI'),
  TimeSlot(time: '11:00 - 13:00', period: 'PAGI'),
  TimeSlot(time: '13:00 - 15:00', period: 'SIANG'),
  TimeSlot(time: '15:00 - 17:00', period: 'SORE'),
  TimeSlot(time: '17:00 - 19:00', period: 'SORE'),
  TimeSlot(time: '19:00 - 21:00', period: 'MALAM'),
];

/// Mock slot yang sudah terisi, per tanggal (index ke [kTimeSlots]).
const Map<int, List<int>> _bookedByDay = {
  11: [1],
  14: [0, 2],
  15: [1, 3],
  16: [4],
  18: [1],
  19: [0, 3],
  20: [2],
  22: [1, 4],
  24: [0, 5],
  25: [3],
  26: [1, 2],
  27: [4],
};

Set<int> bookedSlotIndexes(DateTime date) =>
    (_bookedByDay[date.day] ?? const <int>[]).toSet();