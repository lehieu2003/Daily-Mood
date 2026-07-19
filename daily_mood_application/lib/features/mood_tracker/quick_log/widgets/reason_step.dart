import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../domain/models/mood_activity.dart';
import '../../cubit/mood_form_cubit.dart';
import 'quick_log_theme.dart';
import 'search_field.dart';

class ReasonStep extends StatefulWidget {
  const ReasonStep({
    required this.activities,
    required this.selectedIds,
    required this.onCreateReason,
    super.key,
  });

  final Stream<List<MoodActivity>> activities;
  final Set<int> selectedIds;
  final Future<int> Function(String name) onCreateReason;

  @override
  State<ReasonStep> createState() => _ReasonStepState();
}

class _ReasonStepState extends State<ReasonStep> {
  final _searchController = TextEditingController();
  final _addController = TextEditingController();
  String _query = '';
  bool _showAddField = false;
  bool _isAdding = false;

  @override
  void dispose() {
    _searchController.dispose();
    _addController.dispose();
    super.dispose();
  }

  Future<void> _addReason(List<MoodActivity> allReasons) async {
    final name = _addController.text.trim();
    if (name.isEmpty || _isAdding) return;

    if (name.length > 20) {
      _showMessage(context.l10n.reasonTooLong);
      return;
    }

    MoodActivity? existing;
    for (final reason in allReasons) {
      if (reason.name.toLowerCase() == name.toLowerCase()) {
        existing = reason;
        break;
      }
    }
    if (existing != null) {
      context.read<MoodFormCubit>().toggleActivity(existing.id);
      _addController.clear();
      setState(() => _showAddField = false);
      return;
    }

    setState(() => _isAdding = true);
    try {
      final id = await widget.onCreateReason(name);
      if (!mounted) return;
      context.read<MoodFormCubit>().toggleActivity(id);
      _addController.clear();
      setState(() => _showAddField = false);
    } catch (error, stackTrace) {
      debugPrint('[DailyMood][reasons] Could not add reason: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      _showMessage(context.l10n.couldNotAddReason);
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleComposer() {
    setState(() {
      _showAddField = !_showAddField;
      if (!_showAddField) {
        _addController.clear();
      }
    });
  }

  void _updateQuery(String value) {
    setState(() => _query = value.trim().toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StreamBuilder<List<MoodActivity>>(
      stream: widget.activities,
      builder: (context, snapshot) {
        final allReasons = snapshot.data ?? const <MoodActivity>[];
        final visibleReasons = _query.isEmpty
            ? allReasons
            : allReasons
                  .where((reason) => reason.name.toLowerCase().contains(_query))
                  .toList();
        final recent = visibleReasons.take(4).toList();
        debugPrint(
          '[DailyMood][reasons] ReasonStep snapshot '
          'state=${snapshot.connectionState.name} '
          'hasData=${snapshot.hasData} '
          'hasError=${snapshot.hasError} '
          'count=${allReasons.length} '
          'selected=${widget.selectedIds.toList()}; '
          'names=${allReasons.map((reason) => reason.name).join(', ')}',
        );
        if (snapshot.hasError) {
          debugPrint(
            '[DailyMood][reasons] ReasonStep stream error: '
            '${snapshot.error}',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuickLogSearchField(
              fieldKey: const ValueKey('quick_log_reason_search_field'),
              controller: _searchController,
              enabled: !_isAdding,
              hintText: l10n.searchReasons,
              onChanged: _updateQuery,
            ),
            const SizedBox(height: 18),
            if (_showAddField) ...[
              QuickLogSearchField(
                fieldKey: const ValueKey('quick_log_add_reason_field'),
                controller: _addController,
                enabled: !_isAdding,
                hintText: l10n.addAReason,
                autofocus: true,
                onSubmitted: (_) => _addReason(allReasons),
                onConfirmPressed: () => _addReason(allReasons),
              ),
              const SizedBox(height: 18),
            ],
            _ReasonSectionHeader(
              label: widget.selectedIds.isEmpty
                  ? l10n.selected
                  : l10n.selectedCount(widget.selectedIds.length),
              actionLabel: widget.selectedIds.isEmpty ? null : l10n.clearAll,
              onAction: widget.selectedIds.isEmpty
                  ? null
                  : context.read<MoodFormCubit>().clearActivities,
            ),
            if (widget.selectedIds.isNotEmpty) ...[
              const SizedBox(height: 10),
              _ReasonChipWrap(
                reasons: allReasons
                    .where((reason) => widget.selectedIds.contains(reason.id))
                    .toList(),
                selectedIds: widget.selectedIds,
                onMorePressed: _isAdding ? null : _toggleComposer,
              ),
            ],
            const SizedBox(height: 18),
            _ReasonSectionHeader(label: l10n.recentlyUsed),
            const SizedBox(height: 10),
            _ReasonChipWrap(
              reasons: recent,
              selectedIds: widget.selectedIds,
              onMorePressed: _isAdding ? null : _toggleComposer,
            ),
            const SizedBox(height: 18),
            _ReasonSectionHeader(label: l10n.allReasons),
            const SizedBox(height: 10),
            _ReasonChipWrap(
              reasons: visibleReasons,
              selectedIds: widget.selectedIds,
              onMorePressed: _isAdding ? null : _toggleComposer,
            ),
          ],
        );
      },
    );
  }
}

class _ReasonChipWrap extends StatelessWidget {
  const _ReasonChipWrap({
    required this.reasons,
    required this.selectedIds,
    required this.onMorePressed,
  });

  final List<MoodActivity> reasons;
  final Set<int> selectedIds;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quickLogTheme = QuickLogTheme.of(context);
    if (reasons.isEmpty) {
      return Text(
        l10n.noReasonsYet,
        style: AppTypography.subText2Regular.copyWith(
          color: quickLogTheme.tertiaryText,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: [
        ...reasons.map((reason) {
          final selected = selectedIds.contains(reason.id);
          return FilterChip(
            key: ValueKey('reason_${reason.id}'),
            label: Text(l10n.activityLabel(reason.name)),
            selected: selected,
            onSelected: (_) =>
                context.read<MoodFormCubit>().toggleActivity(reason.id),
            selectedColor: quickLogTheme.cardColor,
            backgroundColor: quickLogTheme.subtleCardColor.withValues(
              alpha: selected ? 1 : 0,
            ),
            showCheckmark: false,
            labelStyle: AppTypography.subText2Medium.copyWith(
              color: selected
                  ? AppColors.primaryPurple
                  : quickLogTheme.primaryText,
            ),
            side: BorderSide(
              color: selected ? AppColors.primaryPurple : quickLogTheme.outline,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          );
        }),
        ActionChip(
          key: const ValueKey('quick_log_more_reason'),
          avatar: const Icon(Icons.add, size: 16),
          label: Text(l10n.more),
          onPressed: onMorePressed,
          backgroundColor: quickLogTheme.cardColor,
          labelStyle: AppTypography.subText2Medium.copyWith(
            color: quickLogTheme.primaryText,
          ),
          side: BorderSide(color: quickLogTheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ],
    );
  }
}

class _ReasonSectionHeader extends StatelessWidget {
  const _ReasonSectionHeader({
    required this.label,
    this.actionLabel,
    this.onAction,
  });

  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final quickLogTheme = QuickLogTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.subText2Medium.copyWith(
              color: quickLogTheme.primaryText,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
