import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neo_box.dart';
import 'neo_button.dart';
import 'neo_tag.dart';
import 'page_shell.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  final _emailC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  void _subscribe() {
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_emailC.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Terima kasih! Kamu terdaftar di buletin.' : 'Format email belum valid.'),
    ));
    if (ok) _emailC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 24),
      child: ContentWrap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(builder: (context, c) {
              final w = c.maxWidth >= 860 ? 400.0 : c.maxWidth - 8;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  SizedBox(
                    width: w,
                    child: NeoBox(
                      color: AppColors.mint,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('STUDIOLENS // HUB', style: AppText.heading(20)),
                          const SizedBox(height: 12),
                          Text(
                            'Platform kurasi dan sewa studio fotografi & videografi profesional dengan transparansi slot instan, equipment staging, dan proteksi jadwal terintegrasi.',
                            style: AppText.body(13, color: Colors.black87),
                          ),
                          const SizedBox(height: 14),
                          const NeoTag(
                              text: 'PRO PRODUCTION STANDARDS',
                              color: Colors.white,
                              fontSize: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: w,
                    child: NeoBox(
                      color: const Color(0xFFF8F8F8),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BULLETIN PRODUKSI'.replaceAll('BULLETIN', 'BULLETIN'),
                              style: AppText.heading(18)),
                          const SizedBox(height: 8),
                          Text(
                            'Dapatkan promo eksklusif tengah malam dan slot kosong studio premier setiap pekan.',
                            style: AppText.body(12, color: Colors.black54),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _emailC,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: neoInput('email.kreatif@studio.com'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              NeoButton(
                                label: 'KIRIM',
                                color: AppColors.blue,
                                textColor: Colors.white,
                                onTap: _subscribe,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 32),
            Container(height: 3, color: AppColors.black),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 20,
              runSpacing: 10,
              children: [
                Text('© 2025 STUDIOLENS INDONESIA. SELURUH HAK CIPTA DILINDUNGI.',
                    style: AppText.label(11, color: Colors.black87)),
                Wrap(
                  spacing: 20,
                  children: [
                    Text('SYARAT & KETENTUAN', style: AppText.label(10)),
                    Text('KEBIJAKAN SEWA', style: AppText.label(10)),
                    Text('SECURITY DEPOSIT', style: AppText.label(10)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}