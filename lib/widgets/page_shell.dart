import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_footer.dart';
import 'app_top_bar.dart';

/// Membatasi lebar konten & memberi padding horizontal responsif.
class ContentWrap extends StatelessWidget {
  const ContentWrap({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w < 600 ? 16 : 40),
          child: child,
        ),
      ),
    );
  }
}

/// Kerangka halaman: TopBar + area pink + Footer.
class PageShell extends StatelessWidget {
  const PageShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final minH = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppTopBar(),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: minH),
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: const BoxDecoration(
                color: AppColors.pink,
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 3),
                ),
              ),
              child: ContentWrap(child: child),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}