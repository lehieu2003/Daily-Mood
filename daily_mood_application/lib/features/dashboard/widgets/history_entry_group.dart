import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';
import 'history_entry_tile.dart';

class HistoryEntryGroup extends StatelessWidget {
  const HistoryEntryGroup({
    required this.date,
    required this.entries,
    super.key,
    this.onOpenEntry,
  });

  final DateTime date;
  final List<MoodEntryModel> entries;
  final ValueChanged<MoodEntryModel>? onOpenEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localizedHistoryGroupLabel(date, context.l10n),
          style: TextStyle(
            color: DashboardPalette.deepText,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: DashboardPalette.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              for (var index = 0; index < entries.length; index++) ...[
                HistoryEntryTile(
                  entry: entries[index],
                  onOpenDetail: onOpenEntry == null
                      ? null
                      : () => onOpenEntry!(entries[index]),
                ),
                if (index != entries.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: DashboardPalette.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
