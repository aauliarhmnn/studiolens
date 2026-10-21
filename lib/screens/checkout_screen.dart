import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_data.dart';
import '../models/booking_data.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/neo_box.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_tag.dart';
import '../widgets/page_shell.dart';
import '../widgets/package_image.dart';

enum PaymentMethod { qris, virtualAccount, card }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.booking});
  final BookingData booking;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _waC = TextEditingController();
  final _emailC = TextEditingController();
  final _notesC = TextEditingController();
  final _promoC = TextEditingController();

  PaymentMethod _method = PaymentMethod.qris;
  String? _appliedCode;
  int _discount = 0;
  String? _promoError;

  BookingData get _b => widget.booking;

  int get _total {
    final t = _b.subtotal - _discount;
    return t < 0 ? 0 : t;
  }

  String get _methodName {
    switch (_method) {
      case PaymentMethod.qris:
        return 'QRIS Instant';
      case PaymentMethod.virtualAccount:
        return 'Virtual Account';
      case PaymentMethod.card:
        return 'Kartu Kredit / Debit';
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _waC.dispose();
    _emailC.dispose();
    _notesC.dispose();
    _promoC.dispose();
    super.dispose();
  }

  // ---------- Aksi ----------
  void _applyPromo() {
    final code = _promoC.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _promoError = 'Masukkan kode promo terlebih dahulu.');
      return;
    }
    final disc = kPromoCodes[code];
    if (disc == null) {
      setState(() {
        _promoError = 'Kode promo tidak valid.';
        _appliedCode = null;
        _discount = 0;
      });
      return;
    }
    setState(() {
      _appliedCode = code;
      _discount = disc;
      _promoError = null;
      _promoC.text = code;
    });
  }

  void _removePromo() {
    setState(() {
      _appliedCode = null;
      _discount = 0;
      _promoError = null;
      _promoC.clear();
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _confirm() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _snack('Lengkapi Data Pemesan terlebih dahulu.');
      return;
    }
    _showSuccess();
  }

  void _showSuccess() {
    final code = 'SL-${(DateTime.now().millisecondsSinceEpoch % 900000) + 100000}';

    Widget row(String l, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(l, style: AppText.label(11, color: Colors.black54))),
              Flexible(
                child: Text(v, textAlign: TextAlign.right, style: AppText.label(12)),
              ),
            ],
          ),
        );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: SingleChildScrollView(
            child: NeoBox(
              shadowOffset: 8,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.black, width: 3),
                      ),
                      child: const Icon(Icons.check, size: 36),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('BOOKING BERHASIL!',
                      textAlign: TextAlign.center, style: AppText.heading(28)),
                  const SizedBox(height: 6),
                  Text('E-tiket dikirim ke ${_emailC.text.trim()} & WhatsApp.',
                      textAlign: TextAlign.center,
                      style: AppText.body(12, color: Colors.black54)),
                  const SizedBox(height: 16),
                  Center(child: NeoTag(text: 'KODE: $code', color: AppColors.lime, fontSize: 14)),
                  const SizedBox(height: 16),
                  Container(height: 2, color: AppColors.black),
                  const SizedBox(height: 8),
                  row('PAKET', _b.package.title),
                  row('TANGGAL', _b.dateLabel),
                  row('JAM', '${_b.slot.time} $kTimeZone'),
                  row('PEMBAYARAN', _methodName),
                  row('TOTAL', formatRupiah(_total)),
                  const SizedBox(height: 18),
                  NeoButton(
                    label: 'KEMBALI KE BERANDA',
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 28);

    return PageShell(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _steps(),
            const SizedBox(height: 24),
            _header(),
            gap,
            LayoutBuilder(builder: (context, c) {
              if (c.maxWidth >= 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [_dataPemesan(), gap, _rincian()],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [_payment(), gap, _promo(), gap, _confirmCard(), gap, _security()],
                      ),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _dataPemesan(), gap,
                  _payment(), gap,
                  _rincian(), gap,
                  _promo(), gap,
                  _confirmCard(), gap,
                  _security(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // ---------- Step indicator & header ----------
  Widget _steps() {
    return Wrap(
      spacing: 18,
      runSpacing: 12,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: NeoBox(
              shadowOffset: 3,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20, height: 20, alignment: Alignment.center,
                    color: AppColors.black,
                    child: Text('1', style: AppText.label(11, color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  Text('PILIH JADWAL', style: AppText.label(12)),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_outline, size: 18, color: AppColors.royal),
                ],
              ),
            ),
          ),
        ),
        NeoBox(
          color: AppColors.blue,
          shadowOffset: 3,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20, height: 20, alignment: Alignment.center,
                color: AppColors.lime,
                child: Text('2', style: AppText.label(11)),
              ),
              const SizedBox(width: 8),
              Text('RINCIAN & PEMBAYARAN', style: AppText.label(12, color: Colors.white)),
              const SizedBox(width: 8),
              const NeoTag(text: '★ AKTIF', color: AppColors.lime, fontSize: 9),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header() {
    final narrow = MediaQuery.of(context).size.width < 700;
    return NeoBox(
      shadowOffset: 8,
      padding: EdgeInsets.all(narrow ? 18 : 28),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 20,
        runSpacing: 16,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NeoTag(text: 'TERMINAL BOOKING RESMI', color: AppColors.lime, fontSize: 10),
                const SizedBox(height: 10),
                Text('RINGKASAN PEMESANAN & CHECKOUT',
                    style: AppText.heading(narrow ? 26 : 46)),
                const SizedBox(height: 10),
                Text(
                  'Lengkapi informasi pemesan dan selesaikan pembayaran untuk mengunci slot studio Anda. Konfirmasi otomatis langsung aktif.',
                  style: AppText.body(13, color: Colors.black87),
                ),
              ],
            ),
          ),
          NeoBox(
            color: Colors.white,
            shadowOffset: 3,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_clock, size: 24, color: AppColors.royal),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STATUS SESI RESERVASI',
                        style: AppText.label(9, color: Colors.black54)),
                    Text(
                      'SLOT TERIKAT (HOLD)',
                      style: AppText.label(12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Data pemesan ----------
  Widget _label(String text, {bool required = false, String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(text: text, style: AppText.label(11)),
              if (required)
                TextSpan(text: ' *', style: AppText.label(11, color: AppColors.red)),
            ])),
          ),
          if (trailing != null)
            Text(trailing, style: AppText.label(9, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title, String? tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.royal, size: 24),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: AppText.heading(22))),
            if (tag != null) NeoTag(text: tag, color: AppColors.lime, fontSize: 10),
          ],
        ),
        const SizedBox(height: 12),
        Container(height: 3, color: AppColors.black),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _dataPemesan() {
    final nameField = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label('NAMA LENGKAP', required: true, trailing: 'SESUAI KTP / ID RESMI'),
        TextFormField(
          controller: _nameC,
          textCapitalization: TextCapitalization.words,
          decoration: neoInput('Nama lengkap'),
          validator: (v) =>
              (v == null || v.trim().length < 3) ? 'Nama minimal 3 karakter.' : null,
        ),
      ],
    );

    final waField = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label('NOMOR WHATSAPP (AKTIF)', required: true),
        TextFormField(
          controller: _waC,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ]'))],
          decoration: neoInput('+62 812-3456-7890'),
          validator: (v) {
            final digits = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
            return digits.length < 9 ? 'Nomor WhatsApp belum valid.' : null;
          },
        ),
        const SizedBox(height: 4),
        Text('E-tiket & instruksi akses studio akan dikirimkan via WA',
            style: AppText.body(10, color: Colors.black54)),
      ],
    );

    final emailField = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label('EMAIL KONFIRMASI', required: true),
        TextFormField(
          controller: _emailC,
          keyboardType: TextInputType.emailAddress,
          decoration: neoInput('nama@email.com'),
          validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch((v ?? '').trim())
              ? null
              : 'Format email belum valid.',
        ),
        const SizedBox(height: 4),
        Text('Invoice pajak digital otomatis dikirim ke email',
            style: AppText.body(10, color: Colors.black54)),
      ],
    );

    return NeoBox(
      shadowOffset: 8,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(Icons.badge_outlined, 'DATA PEMESAN', 'LANGKAH 01'),
          nameField,
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            if (c.maxWidth >= 520) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: waField),
                  const SizedBox(width: 16),
                  Expanded(child: emailField),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [waField, const SizedBox(height: 18), emailField],
            );
          }),
          const SizedBox(height: 18),
          _label('CATATAN KHUSUS / KEPERLUAN PROPERTI (OPSIONAL)', trailing: 'MAKS. 250 KARAKTER'),
          TextFormField(
            controller: _notesC,
            maxLength: 250,
            maxLines: 3,
            decoration: neoInput(
                'Contoh: Mohon siapkan background warna abu-abu seamless, C-stand 4 unit, dan stopkontak tambahan.'),
          ),
        ],
      ),
    );
  }

  // ---------- Metode pembayaran ----------
  Widget _payment() {
    return NeoBox(
      shadowOffset: 8,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(Icons.payments_outlined, 'METODE PEMBAYARAN', 'LANGKAH 02'),
          Text('PILIH SALAH SATU METODE PEMBAYARAN INSTAN:',
              style: AppText.label(10, color: Colors.black54)),
          const SizedBox(height: 14),
          _PaymentTile(
            selected: _method == PaymentMethod.qris,
            onTap: () => setState(() => _method = PaymentMethod.qris),
            title: 'QRIS INSTANT',
            badge: const NeoTag(
                text: 'TERVERIFIKASI OTOMATIS',
                color: Color(0xFF0A4DFF),
                textColor: Colors.white,
                fontSize: 8),
            description: 'GoPay, OVO, Dana, ShopeePay, BCA Mobile & Seluruh Bank',
            trailing: const Icon(Icons.qr_code_2, size: 44),
            footer: Row(
              children: [
                Expanded(
                  child: Text('Bebas Biaya Admin Transaksi',
                      style: AppText.body(11)),
                ),
                Text('LANGSUNG AKTIF',
                    style: AppText.label(10, color: AppColors.royal)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _PaymentTile(
            selected: _method == PaymentMethod.virtualAccount,
            onTap: () => setState(() => _method = PaymentMethod.virtualAccount),
            title: 'VIRTUAL ACCOUNT',
            brands: 'BCA / MANDIRI / BNI / BRI',
            description: 'Nomor VA unik diterbitkan setelah konfirmasi booking.',
          ),
          const SizedBox(height: 14),
          _PaymentTile(
            selected: _method == PaymentMethod.card,
            onTap: () => setState(() => _method = PaymentMethod.card),
            title: 'KARTU KREDIT / DEBIT',
            brands: 'VISA / MASTERCARD / JCB',
            description: 'Enkripsi 3D-Secure langsung via payment gateway resmi.',
          ),
        ],
      ),
    );
  }

  // ---------- Promo ----------
  Widget _promo() {
    return NeoBox(
      shadowOffset: 8,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.local_activity_outlined, color: AppColors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('KODE PROMO ATAU VOUCHER KREATOR',
                    style: AppText.label(12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoC,
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: (_) => _applyPromo(),
                  decoration: neoInput('Masukkan kode (coba: NEUBRUTAL20)'),
                  style: AppText.label(14),
                ),
              ),
              const SizedBox(width: 10),
              NeoButton(
                label: 'TERAPKAN',
                color: AppColors.blue,
                textColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                onTap: _applyPromo,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_appliedCode != null)
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF2E7D32)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Kupon Diskon ${formatRupiah(_discount)} Aktif',
                      style: AppText.label(11, color: const Color(0xFF2E7D32))),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _removePromo,
                    child: Text('HAPUS',
                        style: AppText.label(11, color: AppColors.red)
                            .copyWith(decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            )
          else if (_promoError != null)
            Text(_promoError!, style: AppText.label(11, color: AppColors.red))
          else
            Text('Masukkan kode lalu tekan TERAPKAN.',
                style: AppText.body(11, color: Colors.black54)),
        ],
      ),
    );
  }

  // ---------- Tombol konfirmasi ----------
  Widget _confirmCard() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _confirm,
        child: NeoBox(
          color: AppColors.blue,
          shadowOffset: 8,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LANGKAH TERAKHIR RESERVASI',
                  style: AppText.label(10, color: AppColors.lime)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text('KONFIRMASI BOOKING & BAYAR',
                        style: AppText.heading(26, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      border: Border.all(color: AppColors.black, width: 3),
                      boxShadow: const [
                        BoxShadow(
                            color: AppColors.black,
                            offset: Offset(3, 3),
                            blurRadius: 0)
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward, size: 26),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              NeoTag(
                  text: 'TOTAL: ${formatRupiah(_total).toUpperCase()}',
                  color: AppColors.lime,
                  fontSize: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _security() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NeoBox(
          shadowOffset: 4,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 6),
                  Text('JAMINAN KEAMANAN TRANSAKSI RESMI', style: AppText.label(10)),
                ],
              ),
              const SizedBox(height: 8),
              Container(height: 1, color: Colors.black26),
              const SizedBox(height: 8),
              Text(
                '🔒 100% Enkripsi Aman • Tiket QR Code Langsung Terbit ke WhatsApp & Email • Invoice Resmi Diterbitkan Otomatis oleh PT StudioLens Karya Nusantara.',
                style: AppText.body(11, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 12,
          children: [
            Text('Butuh faktur perusahaan (B2B)?', style: AppText.body(11)),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _snack('Concierge studio — segera hadir (demo)'),
                child: Text('HUBUNGI CONCIERGE STUDIO',
                    style: AppText.label(10)
                        .copyWith(decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Rincian pesanan ----------
  Widget _rincian() {
    final b = _b;

    Widget billRow(String title, String sub, String amount,
        {Widget? tag, Color? amountColor, bool last = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.black, width: 2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(title, style: AppText.label(12)),
                      if (tag != null) tag,
                    ],
                  ),
                  if (sub.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(sub, style: AppText.body(10, color: Colors.black54)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(amount,
                style: AppText.label(14, color: amountColor ?? AppColors.black)),
          ],
        ),
      );
    }

    return NeoBox(
      shadowOffset: 8,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(Icons.receipt_long_outlined, 'RINCIAN PESANAN STUDIO', null),
          // Kartu paket
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              border: Border.all(color: AppColors.black, width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    border: Border.all(color: AppColors.black, width: 3),
                  ),
                  child: PackageImage(path: b.package.image, iconSize: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('PAKET FOTO ${b.package.title}',
                              style: AppText.heading(18)),
                          const NeoTag(
                              text: 'HOT VENUE',
                              color: Colors.white,
                              textColor: AppColors.red,
                              fontSize: 9),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 14,
                        runSpacing: 4,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.royal),
                            const SizedBox(width: 4),
                            Text(b.dateLabel, style: AppText.label(11)),
                          ]),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.schedule, size: 14, color: AppColors.royal),
                            const SizedBox(width: 4),
                            Text('${b.slot.time} $kTimeZone', style: AppText.label(11)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Paket: Foto ${b.package.title}', style: AppText.label(11)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: b.package.features
                            .map((f) => NeoTag(text: f, color: Colors.white, fontSize: 9))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Tabel tagihan
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black, width: 3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: AppColors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('ITEM SPESIFIKASI TAGIHAN',
                            style: AppText.label(10, color: Colors.white)),
                      ),
                      Text('SUBTOTAL (IDR)',
                          style: AppText.label(10, color: Colors.white)),
                    ],
                  ),
                ),
                billRow('Biaya Sewa Studio Reguler',
                    'Sesi Produksi ${formatRupiah(b.basePrice)}',
                    formatRupiah(b.basePrice)),
                billRow('Biaya Kebersihan & Maintenance',
                    'Sanitasi paska-produksi & reset gear stage',
                    formatRupiah(b.cleaningFee),
                    last: _appliedCode == null),
                if (_appliedCode != null)
                  billRow(
                    'Diskon Promo Voucher',
                    '',
                    '-${formatRupiah(_discount)}',
                    tag: NeoTag(text: _appliedCode!, color: AppColors.lime, fontSize: 9),
                    amountColor: const Color(0xFF5A6B00),
                    last: true,
                  ),
                Container(
                  color: AppColors.lime,
                  padding: const EdgeInsets.all(14),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('TOTAL TAGIHAN BERSIH', style: AppText.label(11)),
                          const SizedBox(height: 2),
                          Text('Sudah termasuk PPN 11% & Asuransi Alat Dasar',
                              style: AppText.label(9, color: Colors.black87)),
                        ],
                      ),
                      NeoBox(
                        shadowOffset: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Text(formatRupiah(_total), style: AppText.heading(28)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey,
              border: Border.all(color: AppColors.black, width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Jadwal sewa dapat di-reschedule gratis maksimal 24 jam sebelum waktu sesi dimulai melalui dashboard pesanan Anda.',
                    style: AppText.body(11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Widget kartu metode pembayaran ----------
class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.selected,
    required this.onTap,
    required this.title,
    required this.description,
    this.brands,
    this.badge,
    this.trailing,
    this.footer,
  });

  final bool selected;
  final VoidCallback onTap;
  final String title;
  final String description;
  final String? brands;
  final Widget? badge;
  final Widget? trailing;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: NeoBox(
          color: selected ? AppColors.lime : Colors.white,
          shadowOffset: selected ? 5 : 3,
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: selected ? AppColors.black : Colors.white,
                  border: Border.all(color: AppColors.black, width: 3),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(title, style: AppText.heading(17)),
                        if (badge != null) badge!,
                        if (brands != null)
                          Text(brands!,
                              style: AppText.label(10, color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(description,
                        style: AppText.body(11, color: Colors.black87)),
                    if (footer != null) ...[
                      const SizedBox(height: 8),
                      Container(height: 1, color: Colors.black38),
                      const SizedBox(height: 8),
                      footer!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}