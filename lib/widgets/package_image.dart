import 'package:flutter/material.dart';

class PackageImage extends StatelessWidget {
  const PackageImage({super.key, required this.path, this.iconSize = 56});

  final String path;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Icon(Icons.photo_camera_outlined,
          size: iconSize, color: Colors.black38),
    );

    if (path.isEmpty) return fallback;

    final errorBuilder = (BuildContext c, Object e, StackTrace? s) => fallback;

    return SizedBox.expand(
      child: path.startsWith('http')
          ? Image.network(path, fit: BoxFit.cover, errorBuilder: errorBuilder)
          : Image.asset(path, fit: BoxFit.cover, errorBuilder: errorBuilder),
    );
  }
}