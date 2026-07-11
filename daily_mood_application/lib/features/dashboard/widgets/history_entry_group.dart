import 'package:flutter/material.dart';

import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';
import 'history_entry_tile.dart';

class HistoryEntryGroup extends StatelessWidget {
  const HistoryEntryGroup({
    required this.date,
    required this.entries,
    super.key,
  });

  final DateTime date;
  final List<MoodEntryModel> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          historyGroupLabel(date),
          style: const TextStyle(
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
                HistoryEntryTile(entry: entries[index]),
                if (index != entries.length - 1)
                  const Divider(
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
