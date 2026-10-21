import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neo_button.dart';
import 'page_shell.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  static const _links = ['KATEGORI', 'PROMO SPESIAL', 'CARA BOOKING'];

  void _soon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — segera hadir (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.black, width: 3)),
      ),
      child: ContentWrap(
        child: Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                child: Text('STUDIOLENS',
                    style: AppText.heading(wide ? 26 : 20)),
              ),
            ),
            if (wide) ...[
              const SizedBox(width: 40),
              ..._links.map(
                (l) => Padding(
                  padding: const EdgeInsets.only(right: 28),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _soon(context, l),
                      child: Text(l, style: AppText.label(13)),
                    ),
                  ),
                ),
              ),
            ],
            const Spacer(),
            NeoButton(
              label: wide ? 'MASUK / DAFTAR' : 'MASUK',
              color: AppColors.blue,
              textColor: Colors.white,
              fontSize: 12,
              onTap: () => _soon(context, 'Masuk / Daftar'),
            ),
            const SizedBox(width: 12),
            if (wide)
              GestureDetector(
                onTap: () => _soon(context, 'Profil'),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.pink,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.black, width: 2),
                  ),
                  child: const Icon(Icons.person_outline, size: 20),
                ),
              )
            else
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.menu, color: AppColors.black),
                onSelected: (v) => _soon(context, v),
                itemBuilder: (_) => [
                  ..._links.map((l) => PopupMenuItem(value: l, child: Text(l))),
                  const PopupMenuItem(value: 'Profil', child: Text('PROFIL')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}