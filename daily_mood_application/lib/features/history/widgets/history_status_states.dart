import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../dashboard/dashboard_palette.dart';

class HistoryNoMatchesState extends StatelessWidget {
  const HistoryNoMatchesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('history_no_matches_state'),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.manage_search_rounded,
            color: DashboardPalette.purple,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.noMatchingEntries,
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.noMatchingEntriesBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryLoadingState extends StatelessWidget {
  const HistoryLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(context.l10n.loadingMoodHistory),
        ],
      ),
    );
  }
}

class HistoryErrorState extends StatelessWidget {
  const HistoryErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          context.l10n.couldNotLoadMoodHistory,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
