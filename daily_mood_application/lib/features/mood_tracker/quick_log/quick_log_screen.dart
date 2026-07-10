import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/mood_activity.dart';
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
    required this.onTranscribeVoice,
    required this.onSave,
    this.onCancel,
    this.onDone,
    super.key,
  });

  final Stream<List<MoodActivity>> activities;
  final Future<int> Function(String name) onCreateReason;
  final Future<String?> Function() onPickPhoto;
  final Future<String?> Function() onTranscribeVoice;
  final Future<void> Function(MoodFormState state) onSave;
  final VoidCallback? onCancel;
  final VoidCallback? onDone;

  @override
  State<QuickLogScreen> createState() => _QuickLogScreenState();
}

class _QuickLogScreenState extends State<QuickLogScreen> {
  static const _lastStepIndex = 3;

  int _stepIndex = 0;
  bool _isSaving = false;

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
      if (!mounted) return;
      await _showCompletionDialog(moodScore);
    } catch (error, stackTrace) {
      debugPrint('[DailyMood][quick-log] Could not save mood entry: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save mood entry')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodFormCubit, MoodFormState>(
      builder: (context, state) {
        return QuickLogStepShell(
          stepLabel: '${_stepIndex + 1}/4',
          title: _titleForStep(_stepIndex, state),
          subtitle: _subtitleForStep(_stepIndex),
          primaryLabel: _stepIndex == _lastStepIndex ? 'Save' : 'Continue',
          onPrimaryPressed: _primaryActionForStep(state),
          secondaryLabel: _stepIndex == _lastStepIndex ? 'Skip and Save' : null,
          onSecondaryPressed: state.moodScore == null ? null : _saveAndComplete,
          onBack: _stepIndex == 0 ? null : _goBack,
          onClose: _close,
          child: _childForStep(state),
        );
      },
    );
  }

  String _titleForStep(int stepIndex, MoodFormState state) {
    return switch (stepIndex) {
      0 => "What's your mood now?",
      1 => 'Choose the emotions that make\nyou feel ${_moodLabel(state)}',
      2 => "What's reason making you feel\nthis way?",
      3 => 'Any thing you want to add',
      _ => "What's your mood now?",
    };
  }

  String _subtitleForStep(int stepIndex) {
    return switch (stepIndex) {
      0 =>
        'Select mood that reflects the most how you are\nfeeling at this moment.',
      1 => 'Select at least 1 emotion',
      2 => 'Select reasons that reflected your emotions',
      3 => 'Add your notes on any thought that reflating your mood',
      _ => '',
    };
  }

  String _moodLabel(MoodFormState state) {
    return switch (state.moodScore) {
      1 => 'awful',
      2 => 'bad',
      3 => 'neutral',
      4 => 'good',
      5 => 'amazing',
      _ => 'neutral',
    };
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
      0 => MoodStep(selectedMoodScore: state.moodScore),
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
        onTranscribeVoice: widget.onTranscribeVoice,
      ),
      _ => MoodStep(selectedMoodScore: state.moodScore),
    };
  }
}
