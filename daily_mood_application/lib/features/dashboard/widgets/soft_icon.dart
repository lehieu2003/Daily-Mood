import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class SoftIcon extends StatelessWidget {
  const SoftIcon({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: AppColors.primaryPurple),
    );
  }
}
