import 'package:flutter/material.dart';
import '../models/studio_package.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'neo_box.dart';
import 'neo_button.dart';
import 'neo_tag.dart';
import 'package_image.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package, required this.onOrder});

  final StudioPackage package;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      padding: EdgeInsets.zero,
      shadowOffset: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                  border: Border(
                    bottom: BorderSide(color: AppColors.black, width: 3),
                  ),
                ),
                child: PackageImage(path: package.image),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: NeoTag(
                  text: package.badge,
                  color: package.badgeColor,
                  shadow: true,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(package.title, style: AppText.heading(22)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: package.features
                      .map((f) => NeoTag(text: f, fontSize: 10))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Container(height: 2, color: AppColors.black),
                const SizedBox(height: 10),
                Text('TARIF', style: AppText.label(10, color: Colors.black54)),
                const SizedBox(height: 2),
                Text(formatRupiah(package.price), style: AppText.heading(22)),
                const SizedBox(height: 10),
                Container(height: 2, color: AppColors.black),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(package.category,
                          style: AppText.heading(15)),
                    ),
                    const SizedBox(width: 10),
                    NeoButton(
                      label: 'PESAN SEKARANG',
                      fontSize: 11,
                      onTap: onOrder,
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
}