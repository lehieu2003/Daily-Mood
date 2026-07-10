import 'package:flutter/material.dart';

class EmotionAsset extends StatelessWidget {
  const EmotionAsset({
    required this.path,
    required this.semanticLabel,
    this.size = 20,
    super.key,
  });

  final String path;
  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: semanticLabel,
    );
  }
}
