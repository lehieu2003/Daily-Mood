import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/database/app_database.dart';
import '../../cubit/mood_form_cubit.dart';
import 'search_field.dart';

class ReasonStep extends StatefulWidget {
  const ReasonStep({
    required this.activities,
    required this.selectedIds,
    required this.onCreateReason,
    super.key,
  });

  final Stream<List<Activity>> activities;
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

  Future<void> _addReason(List<Activity> allReasons) async {
    final name = _addController.text.trim();
    if (name.isEmpty || _isAdding) return;

    if (name.length > 20) {
      _showMessage('Reason must be 20 characters or fewer');
      return;
    }

    Activity? existing;
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
      _showMessage('Could not add reason');
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
    return StreamBuilder<List<Activity>>(
      stream: widget.activities,
      builder: (context, snapshot) {
        final allReasons = snapshot.data ?? const <Activity>[];
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
              hintText: 'Search reasons',
              onChanged: _updateQuery,
            ),
            const SizedBox(height: 18),
            if (_showAddField) ...[
              QuickLogSearchField(
                fieldKey: const ValueKey('quick_log_add_reason_field'),
                controller: _addController,
                enabled: !_isAdding,
                hintText: 'Add a reason',
                autofocus: true,
                onSubmitted: (_) => _addReason(allReasons),
                onConfirmPressed: () => _addReason(allReasons),
              ),
              const SizedBox(height: 18),
            ],
            _ReasonSectionHeader(
              label: widget.selectedIds.isEmpty
                  ? 'Selected'
                  : 'Selected (${widget.selectedIds.length})',
              actionLabel: widget.selectedIds.isEmpty ? null : 'Clear all',
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
            const _ReasonSectionHeader(label: 'Recently used'),
            const SizedBox(height: 10),
            _ReasonChipWrap(
              reasons: recent,
              selectedIds: widget.selectedIds,
              onMorePressed: _isAdding ? null : _toggleComposer,
            ),
            const SizedBox(height: 18),
            const _ReasonSectionHeader(label: 'All reasons'),
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

  final List<Activity> reasons;
  final Set<int> selectedIds;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    if (reasons.isEmpty) {
      return Text(
        'No reasons yet',
        style: AppTypography.subText2Regular.copyWith(
          color: AppColors.textTertiary,
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
            label: Text(reason.name),
            selected: selected,
            onSelected: (_) =>
                context.read<MoodFormCubit>().toggleActivity(reason.id),
            selectedColor: Colors.white,
            backgroundColor: Colors.transparent,
            showCheckmark: false,
            labelStyle: AppTypography.subText2Medium.copyWith(
              color: AppColors.textPrimary,
            ),
            side: BorderSide(
              color: selected ? AppColors.primaryPurple : AppColors.textPrimary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          );
        }),
        ActionChip(
          key: const ValueKey('quick_log_more_reason'),
          avatar: const Icon(Icons.add, size: 16),
          label: const Text('More'),
          onPressed: onMorePressed,
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
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.subText2Medium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
