import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_typography.dart';
import '../../cubit/mood_form_cubit.dart';
import '../../cubit/mood_form_state.dart';

class NoteStep extends StatelessWidget {
  const NoteStep({
    required this.state,
    required this.onPickPhoto,
    required this.onStartVoiceRecording,
    required this.onStopVoiceRecording,
    required this.onCancelVoiceRecording,
    super.key,
  });

  final MoodFormState state;
  final Future<String?> Function() onPickPhoto;
  final Future<bool> Function() onStartVoiceRecording;
  final Future<String?> Function() onStopVoiceRecording;
  final Future<void> Function() onCancelVoiceRecording;

  Future<void> _attachPhoto(BuildContext context) async {
    final relativePath = await onPickPhoto();
    if (relativePath == null || !context.mounted) return;
    context.read<MoodFormCubit>().setPhotoRelativePath(relativePath);
  }

  @override
  Widget build(BuildContext context) {
    return _NoteStepBody(
      state: state,
      onStartVoiceRecording: onStartVoiceRecording,
      onStopVoiceRecording: onStopVoiceRecording,
      onCancelVoiceRecording: onCancelVoiceRecording,
      onAttachPhoto: _attachPhoto,
    );
  }
}

class _NoteStepBody extends StatefulWidget {
  const _NoteStepBody({
    required this.state,
    required this.onStartVoiceRecording,
    required this.onStopVoiceRecording,
    required this.onCancelVoiceRecording,
    required this.onAttachPhoto,
  });

  final MoodFormState state;
  final Future<bool> Function() onStartVoiceRecording;
  final Future<String?> Function() onStopVoiceRecording;
  final Future<void> Function() onCancelVoiceRecording;
  final Future<void> Function(BuildContext context) onAttachPhoto;

  @override
  State<_NoteStepBody> createState() => _NoteStepBodyState();
}

class _NoteStepBodyState extends State<_NoteStepBody> {
  late final TextEditingController _noteController;
  bool _isRecording = false;
  bool _isVoiceBusy = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.state.note);
  }

  @override
  void didUpdateWidget(covariant _NoteStepBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.note == _noteController.text) return;

    _noteController.value = _noteController.value.copyWith(
      text: widget.state.note,
      selection: TextSelection.collapsed(offset: widget.state.note.length),
      composing: TextRange.empty,
    );
  }

  @override
  void dispose() {
    if (_isRecording) {
      widget.onCancelVoiceRecording();
    }
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _toggleVoiceRecording() async {
    if (_isVoiceBusy) return;

    setState(() => _isVoiceBusy = true);
    if (!_isRecording) {
      final started = await widget.onStartVoiceRecording();
      if (!mounted) return;
      setState(() {
        _isRecording = started;
        _isVoiceBusy = false;
      });
      if (!started) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required.')),
        );
      }
      return;
    }

    final relativePath = await widget.onStopVoiceRecording();
    if (!mounted) return;
    setState(() {
      _isRecording = false;
      _isVoiceBusy = false;
    });
    if (relativePath == null) return;
    context.read<MoodFormCubit>().setVoiceNoteRelativePath(relativePath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _noteController,
          minLines: 9,
          maxLines: 13,
          textInputAction: TextInputAction.newline,
          onChanged: context.read<MoodFormCubit>().setNote,
          decoration: InputDecoration(
            hintText:
                'How wonderful it is to be with yourself sometimes! I spent a wonderful day taking care of myself.',
            hintStyle: AppTypography.subText2Regular,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const ValueKey('quick_log_attach_photo'),
                onPressed: () => widget.onAttachPhoto(context),
                icon: const Icon(Icons.image_outlined, size: 18),
                label: const Text('Add photo'),
                style: _mediaButtonStyle(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                key: const ValueKey('quick_log_record_voice'),
                onPressed: _isVoiceBusy ? null : _toggleVoiceRecording,
                icon: Icon(
                  _isRecording ? Icons.stop_circle_outlined : Icons.mic,
                  size: 18,
                ),
                label: Text(_isRecording ? 'Stop voice' : 'Add voice'),
                style: _mediaButtonStyle(),
              ),
            ),
          ],
        ),
        if (widget.state.hasPhoto) ...[
          const SizedBox(height: 10),
          _AttachmentTile(
            icon: Icons.image_outlined,
            label: widget.state.photoRelativePath!,
            onClear: context.read<MoodFormCubit>().clearPhoto,
          ),
        ],
        if (widget.state.hasVoiceNote) ...[
          const SizedBox(height: 10),
          _AttachmentTile(
            icon: Icons.graphic_eq_rounded,
            label: widget.state.voiceNoteRelativePath!,
            onClear: context.read<MoodFormCubit>().clearVoiceNote,
          ),
        ],
      ],
    );
  }

  ButtonStyle _mediaButtonStyle() {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.icon,
    required this.label,
    required this.onClear,
  });

  final IconData icon;
  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.subText3Regular,
              ),
            ),
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, size: 18),
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
