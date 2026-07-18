import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/daily_reflection.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_palette.dart';

class DailyReflectionCard extends StatefulWidget {
  const DailyReflectionCard({
    required this.entries,
    required this.selectedDate,
    required this.reflection,
    required this.onSave,
    super.key,
  });

  final List<MoodEntryModel> entries;
  final DateTime selectedDate;
  final DailyReflectionModel? reflection;
  final Future<void> Function({
    required DateTime date,
    required String prompt,
    required String response,
  })
  onSave;

  @override
  State<DailyReflectionCard> createState() => _DailyReflectionCardState();
}

class _DailyReflectionCardState extends State<DailyReflectionCard> {
  late final TextEditingController _controller;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.reflection?.response ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant DailyReflectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reflection?.id != widget.reflection?.id ||
        oldWidget.reflection?.response != widget.reflection?.response) {
      _controller.text = widget.reflection?.response ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prompt = _prompt(l10n);
    final existing = widget.reflection;

    return DecoratedBox(
      key: const ValueKey('daily_reflection_card'),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DashboardPalette.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: DashboardPalette.lilacPanel,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.nightlight_round, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyReflection,
                        style: TextStyle(
                          color: DashboardPalette.deepText,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.dailyReflectionSubtitle,
                        style: TextStyle(
                          color: DashboardPalette.mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryChip(text: _moodSummary(l10n)),
                _SummaryChip(text: _emotionSummary(l10n)),
                _SummaryChip(text: _activitySummary(l10n)),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              prompt,
              style: TextStyle(
                color: DashboardPalette.deepText,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const ValueKey('daily_reflection_field'),
              controller: _controller,
              maxLength: 280,
              minLines: 2,
              maxLines: 4,
              enabled: !_isSaving,
              decoration: InputDecoration(
                hintText: l10n.reflectionHint,
                filled: true,
                fillColor: DashboardPalette.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                key: const ValueKey('daily_reflection_save_button'),
                onPressed: _isSaving ? null : () => _save(prompt),
                style: FilledButton.styleFrom(
                  backgroundColor: DashboardPalette.purple,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        existing == null
                            ? l10n.saveReflection
                            : l10n.editReflection,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(String prompt) async {
    final response = _controller.text.trim();
    if (response.isEmpty) return;

    setState(() => _isSaving = true);
    await widget.onSave(
      date: widget.selectedDate,
      prompt: prompt,
      response: response,
    );
    if (mounted) setState(() => _isSaving = false);
  }

  String _prompt(AppLocalizations l10n) {
    return widget.reflection?.prompt ?? l10n.dailyReflectionPrompt;
  }

  String _moodSummary(AppLocalizations l10n) {
    return l10n.todayFelt(l10n.moodLabel(_dominantMoodScore()));
  }

  String _emotionSummary(AppLocalizations l10n) {
    final emotion = _mostCommonEmotion();
    return l10n.commonEmotion(
      emotion == null
          ? l10n.noneYet
          : l10n.subEmotionLabel(emotion.id, emotion.name),
    );
  }

  String _activitySummary(AppLocalizations l10n) {
    final activity = _mostCommonActivity();
    return l10n.commonReason(
      activity == null ? l10n.noneYet : l10n.activityLabel(activity.name),
    );
  }

  int _dominantMoodScore() {
    final counts = <int, int>{};
    for (final entry in widget.entries) {
      counts.update(entry.moodScore, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.entries.reduce((best, current) {
      if (current.value != best.value) {
        return current.value > best.value ? current : best;
      }
      return current.key > best.key ? current : best;
    }).key;
  }

  _NamedId? _mostCommonEmotion() {
    final counts = <int, _NamedCount>{};
    for (final entry in widget.entries) {
      for (var index = 0; index < entry.subEmotionIds.length; index++) {
        final id = entry.subEmotionIds[index];
        final name = index < entry.subEmotionNames.length
            ? entry.subEmotionNames[index]
            : id.toString();
        counts.update(
          id,
          (count) => _NamedCount(name: count.name, count: count.count + 1),
          ifAbsent: () => _NamedCount(name: name, count: 1),
        );
      }
    }
    return _mostCommon(counts);
  }

  _NamedId? _mostCommonActivity() {
    final counts = <int, _NamedCount>{};
    for (final entry in widget.entries) {
      for (var index = 0; index < entry.activityIds.length; index++) {
        final id = entry.activityIds[index];
        final name = index < entry.activityNames.length
            ? entry.activityNames[index]
            : id.toString();
        counts.update(
          id,
          (count) => _NamedCount(name: count.name, count: count.count + 1),
          ifAbsent: () => _NamedCount(name: name, count: 1),
        );
      }
    }
    return _mostCommon(counts);
  }

  _NamedId? _mostCommon(Map<int, _NamedCount> counts) {
    if (counts.isEmpty) return null;
    final best = counts.entries.reduce((best, current) {
      if (current.value.count != best.value.count) {
        return current.value.count > best.value.count ? current : best;
      }
      return current.key < best.key ? current : best;
    });
    return _NamedId(id: best.key, name: best.value.name);
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.text});

  final String text;

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
          text,
          style: TextStyle(
            color: DashboardPalette.deepText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _NamedCount {
  const _NamedCount({required this.name, required this.count});

  final String name;
  final int count;
}

class _NamedId {
  const _NamedId({required this.id, required this.name});

  final int id;
  final String name;
}
