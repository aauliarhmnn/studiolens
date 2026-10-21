import 'package:flutter/material.dart';

class StudioPackage {
  const StudioPackage({
    required this.id,
    required this.title,
    required this.category,
    required this.badge,
    required this.badgeColor,
    required this.price,
    required this.features,
    this.image = '',
  });

  final String id;
  final String title;
  final String category;
  final String badge;
  final Color badgeColor;
  final int price;
  final List<String> features;
  final String image;
}