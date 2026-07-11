import 'package:flutter/material.dart';

import '../dashboard_palette.dart';

class NatureTipCard extends StatelessWidget {
  const NatureTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Connect with nature',
                  style: TextStyle(
                    color: DashboardPalette.deepText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(Icons.lightbulb_outline, color: Color(0xFFFFB31A), size: 15),
              SizedBox(width: 4),
              Text(
                'Tip',
                style: TextStyle(
                  color: Color(0xFFFFB31A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Spend time outdoors, surrounded by greenery and fresh air',
            style: TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
