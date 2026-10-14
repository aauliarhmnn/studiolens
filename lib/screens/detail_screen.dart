import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/booking_data.dart';
import '../models/studio_package.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/booking_calendar.dart';
import '../widgets/neo_box.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_tag.dart';
import '../widgets/page_shell.dart';
import '../widgets/time_slot_grid.dart';
import 'checkout_screen.dart';
import '../widgets/package_image.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.package});
  final StudioPackage package;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static final DateTime _minMonth = DateTime(2026, 10);
  static final DateTime _maxMonth = DateTime(2026, 12);

  DateTime _month = DateTime(2026, 10);
  DateTime? _date = DateTime(2026, 10, 18);
  int? _slot = 3; // 15:00 - 17:00

  bool get _ready => _date != null && _slot != null;
  int get _total => _ready ? widget.package.price + kCleaningFee : 0;

  void _selectDate(DateTime d) {
    setState(() {
      _date = d;
      // reset slot jika bentrok dengan slot yang sudah terisi di tanggal baru
      if (_slot != null && bookedSlotIndexes(d).contains(_slot)) _slot = null;
    });
  }

  void _goCheckout() {
    final date = _date;
    final idx = _slot;
    if (date == null || idx == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          booking: BookingData(
            package: widget.package,
            date: date,
            slot: kTimeSlots[idx],
            cleaningFee: kCleaningFee,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: NeoButton(
              label: '← KEMBALI',
              color: Colors.white,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(builder: (context, c) {
            if (c.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _leftPanel()),
                  const SizedBox(width: 32),
                  Expanded(flex: 5, child: _bookingPanel()),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _leftPanel(),
                const SizedBox(height: 28),
                _bookingPanel(),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ---------- Panel kiri ----------
  Widget _leftPanel() {
    final p = widget.package;
    final narrow = MediaQuery.of(context).size.width < 600;

    return NeoBox(
      shadowOffset: 8,
      padding: EdgeInsets.all(narrow ? 18 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('PAKET FOTO ${p.title}',
              style: AppText.heading(narrow ? 32 : 54)),
          const SizedBox(height: 14),
          Container(height: 3, color: AppColors.black),
          const SizedBox(height: 22),
          NeoBox(
            shadowOffset: 4,
            padding: EdgeInsets.zero,
            child: AspectRatio(
            aspectRatio: 4 / 3,
            child: PackageImage(path: p.image, iconSize: 72),
          ),
          ),
          const SizedBox(height: 24),
          Text(p.title, style: AppText.heading(34)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: p.features.map((f) => NeoTag(text: f, fontSize: 13)).toList(),
          ),
        ],
      ),
    );
  }

  // ---------- Panel kanan ----------
  Widget _bookingPanel() {
    final p = widget.package;
    final date = _date;
    final idx = _slot;
    final slot = idx == null ? null : kTimeSlots[idx];

    return NeoBox(
      shadowOffset: 8,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('TARIF BASE PRODUCTION',
              style: AppText.label(11, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(formatRupiah(p.price), style: AppText.heading(40)),
          const SizedBox(height: 14),
          Container(height: 3, color: AppColors.black),
          const SizedBox(height: 18),
          _stepHeader('1', 'PILIH TANGGAL SESI', '[$kTimeZone - $kTimeZoneOffset]'),
          const SizedBox(height: 12),
          BookingCalendar(
            month: _month,
            selected: _date,
            onSelect: _selectDate,
            onPrevMonth: _month.isAfter(_minMonth)
                ? () => setState(() => _month = DateTime(_month.year, _month.month - 1))
                : null,
            onNextMonth: _month.isBefore(_maxMonth)
                ? () => setState(() => _month = DateTime(_month.year, _month.month + 1))
                : null,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('TANGGAL TERPILIH:', style: AppText.label(10)),
                NeoTag(
                  text: date == null ? '-' : formatDateLong(date).toUpperCase(),
                  color: AppColors.mint,
                  fontSize: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 3, color: AppColors.black),
          const SizedBox(height: 18),
          _stepHeader('2', 'PILIH JAM SESI (DURASI 2 JAM)', 'SLOT REALTIME'),
          const SizedBox(height: 12),
          if (date == null)
            Text('Pilih tanggal terlebih dahulu untuk melihat slot.',
                style: AppText.body(12, color: Colors.black54))
          else
            TimeSlotGrid(
              date: date,
              selectedIndex: _slot,
              onSelect: (i) => setState(() => _slot = i),
            ),
          const SizedBox(height: 20),
          Container(height: 3, color: AppColors.black),
          const SizedBox(height: 18),
          _summary(date, slot, p),
          const SizedBox(height: 18),
          NeoButton(
            label: 'LANJUT KE PEMBAYARAN →',
            color: AppColors.mint,
            fontSize: 15,
            padding: const EdgeInsets.symmetric(vertical: 18),
            onTap: _ready ? _goCheckout : null,
          ),
          const SizedBox(height: 12),
          Text('⚡ BEBAS PEMBATALAN HINGGA 24 JAM SEBELUM SESI DIMULAI',
              textAlign: TextAlign.center, style: AppText.label(10)),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _stepHeader(String n, String title, String trailing) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          color: AppColors.black,
          child: Text(n, style: AppText.label(12, color: Colors.white)),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: AppText.label(12))),
        Text(trailing, style: AppText.label(10, color: AppColors.royal)),
      ],
    );
  }

  Widget _summary(DateTime? date, dynamic slot, StudioPackage p) {
    Widget line(String l, String v, {bool muted = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(l,
                      style: AppText.label(11,
                          color: muted ? Colors.black54 : AppColors.black))),
              const SizedBox(width: 8),
              Flexible(
                child: Text(v,
                    textAlign: TextAlign.right,
                    style: AppText.label(11)),
              ),
            ],
          ),
        );

    return NeoBox(
      color: const Color(0xFFF3F3F3),
      shadowOffset: 0,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('RINGKASAN BIAYA AWAL // BOOKING SPECS',
              style: AppText.label(10, color: Colors.black54)),
          const SizedBox(height: 8),
          line('SESI STUDIO:',
              (date != null && slot != null)
                  ? '${formatDateShort(date)} • ${slot.time} $kTimeZone'
                  : '-'),
          line('DURASI TERPILIH:', slot != null ? '2 JAM (SESI STANDAR)' : '-'),
          line('BIAYA PAKET (2 JAM):', slot != null ? formatRupiah(p.price) : '-'),
          line('KEBERSIHAN & ASISTEN:',
              slot != null ? formatRupiah(kCleaningFee) : '-',
              muted: true),
          const SizedBox(height: 6),
          Container(height: 2, color: AppColors.black),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: Text('TOTAL SEMENTARA', style: AppText.label(13))),
              Text(formatRupiah(_total),
                  style: AppText.heading(24, color: AppColors.royal)),
            ],
          ),
        ],
      ),
    );
  }
}