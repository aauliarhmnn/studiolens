import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/studio_package.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_box.dart';
import '../widgets/neo_tag.dart';
import '../widgets/package_card.dart';
import '../widgets/page_shell.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _filters = ['ALL', 'PROFESIONAL STUDIO', 'GRADUATION'];
  String _filter = 'ALL';

  List<StudioPackage> get _items => _filter == 'ALL'
      ? kPackages
      : kPackages.where((p) => p.category == _filter).toList();

  void _openDetail(StudioPackage p) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(package: p)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _hero(),
          const SizedBox(height: 32),
          _filterChips(),
          const SizedBox(height: 20),
          _grid(),
          const SizedBox(height: 40),
          _banner(),
        ],
      ),
    );
  }

  Widget _hero() {
    final narrow = MediaQuery.of(context).size.width < 700;
    final size = narrow ? 38.0 : 76.0;

    return NeoBox(
      shadowOffset: 10,
      padding: EdgeInsets.all(narrow ? 20 : 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              NeoTag(text: '★ 100+ STUDIO AKTIF', color: AppColors.blue, shadow: true),
              NeoTag(text: '⚡ INSTANT CONFIRMATION', color: AppColors.lime, shadow: true),
              NeoTag(text: 'VERIFIED GEAR // 2025', color: AppColors.salmon, shadow: true),
            ],
          ),
          const SizedBox(height: 28),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'CAPTURE THE MOMENT.\nKEEP THE ',
                    style: AppText.heading(size)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Transform.rotate(
                    angle: -0.03,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        border: Border.all(color: AppColors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.black,
                              offset: Offset(5, 5),
                              blurRadius: 0)
                        ],
                      ),
                      child: Text('MEMORY.', style: AppText.heading(size)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              'Pesan studio foto dengan mudah, pilih paket sesuai kebutuhan, dan abadikan momen terbaikmu dengan pengalaman foto yang profesional.',
              style: AppText.body(narrow ? 14 : 17),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _filters.map((f) {
        final active = f == _filter;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.black : Colors.white,
                border: Border.all(color: AppColors.black, width: 3),
                boxShadow: active
                    ? null
                    : const [
                        BoxShadow(
                            color: AppColors.black,
                            offset: Offset(3, 3),
                            blurRadius: 0)
                      ],
              ),
              child: Text(f,
                  style: AppText.label(13,
                      color: active ? AppColors.pink : AppColors.black)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _grid() {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 1000 ? 3 : (c.maxWidth >= 640 ? 2 : 1);
      const gap = 28.0;
      final w = (c.maxWidth - gap * (cols - 1) - 10) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: _items
            .map((p) => SizedBox(
                  width: w,
                  child: PackageCard(package: p, onOrder: () => _openDetail(p)),
                ))
            .toList(),
      );
    });
  }

  Widget _banner() {
    Widget item(String t) => Text(t, style: AppText.heading(19, color: const Color(0xFFC9F7C9)));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: const BoxDecoration(
        color: AppColors.black,
        boxShadow: [
          BoxShadow(color: AppColors.black, offset: Offset(6, 6), blurRadius: 0)
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 32,
        runSpacing: 14,
        children: [
          item('★ GARANSI HARGA TERBAIK'),
          item('⚡ BOOKING INSTAN TANPA RIBET'),
          item('📸 LEBIH DARI 5.000+ SESI TERSUKSESKAN'),
        ],
      ),
    );
  }
}