import 'package:flutter/material.dart';

import '../dashboard_palette.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('history_empty_state'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.history,
              color: DashboardPalette.purple,
              size: 44,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'No history yet',
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your saved mood entries will appear here after check-ins.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
