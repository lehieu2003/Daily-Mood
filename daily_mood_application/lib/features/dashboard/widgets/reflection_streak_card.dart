import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_typography.dart';
import '../dashboard_palette.dart';
import '../streak_calculator.dart';
import '../../../domain/models/mood_entry.dart';
import 'dashboard_card_decoration.dart';
import 'soft_icon.dart';

class ReflectionStreakCard extends StatelessWidget {
  const ReflectionStreakCard({
    required this.entries,
    required this.today,
    super.key,
  });

  final List<MoodEntryModel> entries;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final streak = currentReflectionStreak(entries, today: today);

    return Container(
      key: const ValueKey('reflection_streak_card'),
      padding: const EdgeInsets.all(18),
      decoration: dashboardCardDecoration(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 300;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const SoftIcon(icon: Icons.local_fire_department_outlined),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.reflectionStreak,
                          style: AppTypography.subText3Regular,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.streakDayCount(streak),
                          style: AppTypography.heading2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.streakHelper(streak),
                          style: AppTypography.subText2Regular.copyWith(
                            color: DashboardPalette.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 12),
                    Flexible(
                      child: _NoPressureLabel(label: l10n.streakNoPressure),
                    ),
                  ],
                ],
              ),
              if (compact) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _NoPressureLabel(label: l10n.streakNoPressure),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _NoPressureLabel extends StatelessWidget {
  const _NoPressureLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DashboardPalette.lilacPanel,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: AppTypography.subText3Regular.copyWith(
            color: DashboardPalette.purple,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
