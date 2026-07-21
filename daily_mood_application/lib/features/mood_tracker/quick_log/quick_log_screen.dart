import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/mood_activity.dart';
import '../../../app/localization/app_localizations.dart';
import '../cubit/mood_form_cubit.dart';
import '../cubit/mood_form_state.dart';
import 'widgets/completion_dialog.dart';
import 'widgets/emotion_step.dart';
import 'widgets/mood_step.dart';
import 'widgets/note_step.dart';
import 'widgets/quick_log_step_shell.dart';
import 'widgets/reason_step.dart';

class QuickLogScreen extends StatefulWidget {
  const QuickLogScreen({
    required this.activities,
    required this.onCreateReason,
    required this.onPickPhoto,
    required this.onStartVoiceRecording,
    required this.onStopVoiceRecording,
    required this.onCancelVoiceRecording,
    required this.onSave,
    this.onCancel,
    this.onDone,
    this.onDisposeVoiceRecording,
    this.onMoodSelectedHaptic,
    this.onMoodSavedHaptic,
    super.key,
  });

  final Stream<List<MoodActivity>> activities;
  final Future<int> Function(String name) onCreateReason;
  final Future<String?> Function() onPickPhoto;
  final Future<bool> Function() onStartVoiceRecording;
  final Future<String?> Function() onStopVoiceRecording;
  final Future<void> Function() onCancelVoiceRecording;
  final Future<void> Function()? onDisposeVoiceRecording;
  final Future<void> Function(MoodFormState state) onSave;
  final VoidCallback? onCancel;
  final VoidCallback? onDone;
  final Future<void> Function()? onMoodSelectedHaptic;
  final Future<void> Function()? onMoodSavedHaptic;

  @override
  State<QuickLogScreen> createState() => _QuickLogScreenState();
}

class _QuickLogScreenState extends State<QuickLogScreen> {
  static const _lastStepIndex = 3;

  int _stepIndex = 0;
  bool _isSaving = false;

  @override
  void dispose() {
    widget.onDisposeVoiceRecording?.call();
    super.dispose();
  }

  void _goBack() {
    if (_stepIndex == 0) return;
    setState(() => _stepIndex--);
  }

  void _goForward() {
    if (_stepIndex == _lastStepIndex) return;
    setState(() => _stepIndex++);
  }

  void _close() {
    final cancel = widget.onCancel;
    if (cancel != null) {
      cancel();
      return;
    }
    Navigator.of(context).maybePop();
  }

  Future<void> _showCompletionDialog(int moodScore) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return QuickLogCompletionDialog(
          moodScore: moodScore,
          onDismissed: () => Navigator.of(dialogContext).pop(),
        );
      },
    );

    widget.onDone?.call();
  }

  Future<void> _saveAndComplete() async {
    final state = context.read<MoodFormCubit>().state;
    final moodScore = state.moodScore;
    if (moodScore == null || _isSaving) return;

    setState(() => _isSaving = true);
    try {
      await widget.onSave(state);
      unawaited(widget.onMoodSavedHaptic?.call());
      if (!mounted) return;
      await _showCompletionDialog(moodScore);
    } catch (error, stackTrace) {
      debugPrint('[DailyMood][quick-log] Could not save mood entry: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.couldNotSaveMoodEntry)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<MoodFormCubit, MoodFormState>(
      builder: (context, state) {
        return QuickLogStepShell(
          stepLabel: '${_stepIndex + 1}/4',
          title: _titleForStep(l10n, _stepIndex, state),
          subtitle: _subtitleForStep(l10n, _stepIndex),
          primaryLabel: _stepIndex == _lastStepIndex
              ? l10n.save
              : l10n.continueLabel,
          onPrimaryPressed: _primaryActionForStep(state),
          secondaryLabel: _stepIndex == _lastStepIndex
              ? l10n.skipAndSave
              : null,
          onSecondaryPressed: state.moodScore == null ? null : _saveAndComplete,
          onBack: _stepIndex == 0 ? null : _goBack,
          onClose: _close,
          child: _childForStep(state),
        );
      },
    );
  }

  String _titleForStep(
    AppLocalizations l10n,
    int stepIndex,
    MoodFormState state,
  ) {
    return switch (stepIndex) {
      0 => l10n.whatsYourMoodNow,
      1 => l10n.quickLogEmotionTitle(_moodLabel(l10n, state)),
      2 => l10n.quickLogReasonTitle,
      3 => l10n.quickLogNoteTitle,
      _ => l10n.whatsYourMoodNow,
    };
  }

  String _subtitleForStep(AppLocalizations l10n, int stepIndex) {
    return switch (stepIndex) {
      0 => l10n.quickLogMoodSubtitle,
      1 => l10n.selectAtLeastOneEmotion,
      2 => l10n.quickLogReasonSubtitle,
      3 => l10n.quickLogNoteSubtitle,
      _ => '',
    };
  }

  String _moodLabel(AppLocalizations l10n, MoodFormState state) {
    return l10n.moodFeelingLabel(state.moodScore);
  }

  VoidCallback? _primaryActionForStep(MoodFormState state) {
    if (_isSaving) return null;

    return switch (_stepIndex) {
      0 => state.moodScore == null ? null : _goForward,
      1 => state.selectedSubEmotionIds.isEmpty ? null : _goForward,
      2 => state.selectedActivityIds.isEmpty ? null : _goForward,
      3 => state.moodScore == null ? null : _saveAndComplete,
      _ => null,
    };
  }

  Widget _childForStep(MoodFormState state) {
    return switch (_stepIndex) {
      0 => MoodStep(
        selectedMoodScore: state.moodScore,
        onMoodSelectedHaptic: widget.onMoodSelectedHaptic,
      ),
      1 => EmotionStep(
        selectedMoodScore: state.moodScore,
        selectedIds: state.selectedSubEmotionIds,
      ),
      2 => ReasonStep(
        activities: widget.activities,
        selectedIds: state.selectedActivityIds,
        onCreateReason: widget.onCreateReason,
      ),
      3 => NoteStep(
        state: state,
        onPickPhoto: widget.onPickPhoto,
        onStartVoiceRecording: widget.onStartVoiceRecording,
        onStopVoiceRecording: widget.onStopVoiceRecording,
        onCancelVoiceRecording: widget.onCancelVoiceRecording,
      ),
      _ => MoodStep(
        selectedMoodScore: state.moodScore,
        onMoodSelectedHaptic: widget.onMoodSelectedHaptic,
      ),
    };
  }
}
