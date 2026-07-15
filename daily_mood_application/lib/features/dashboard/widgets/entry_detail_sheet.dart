import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/mood_activity.dart';
import '../../../domain/models/mood_entry.dart';
import '../../mood_tracker/quick_log/quick_log_media_service.dart';
import '../../mood_tracker/quick_log/quick_log_options.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';
import '../entry_detail_actions.dart';
import 'entry_mood_selector.dart';

Future<void> showEntryDetailSheet({
  required BuildContext context,
  required MoodEntryModel entry,
  required EntryUpdateAction onUpdateEntry,
  required EntryDeleteAction onDeleteEntry,
  Stream<List<MoodActivity>>? activityOptions,
  QuickLogMediaService? mediaService,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return EntryDetailSheet(
        entry: entry,
        onUpdateEntry: onUpdateEntry,
        onDeleteEntry: onDeleteEntry,
        activityOptions: activityOptions,
        mediaService: mediaService ?? QuickLogMediaService(),
      );
    },
  );
}

class EntryDetailSheet extends StatefulWidget {
  const EntryDetailSheet({
    required this.entry,
    required this.onUpdateEntry,
    required this.onDeleteEntry,
    super.key,
    this.activityOptions,
    this.mediaService,
  });

  final MoodEntryModel entry;
  final EntryUpdateAction onUpdateEntry;
  final EntryDeleteAction onDeleteEntry;
  final Stream<List<MoodActivity>>? activityOptions;
  final QuickLogMediaService? mediaService;

  @override
  State<EntryDetailSheet> createState() => _EntryDetailSheetState();
}

class _EntryDetailSheetState extends State<EntryDetailSheet> {
  late int _selectedScore;
  late final TextEditingController _noteController;
  late final Set<int> _selectedActivityIds;
  late final Set<int> _selectedSubEmotionIds;
  String? _photoRelativePath;
  String? _voiceNotePath;
  var _isSaving = false;
  var _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _selectedScore = widget.entry.moodScore;
    _noteController = TextEditingController(text: widget.entry.note ?? '');
    _selectedActivityIds = widget.entry.activityIds.toSet();
    _selectedSubEmotionIds = widget.entry.subEmotionIds.toSet();
    _photoRelativePath = widget.entry.photoRelativePath;
    _voiceNotePath = widget.entry.voiceNotePath;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isBusy = _isSaving || _isDeleting;
    final l10n = context.l10n;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        key: const ValueKey('entry_detail_sheet'),
        decoration: const BoxDecoration(
          color: DashboardPalette.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: DashboardPalette.divider,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizedMoodLabel(_selectedScore, l10n),
                          style: const TextStyle(
                            color: DashboardPalette.deepText,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatLocalizedEntryDate(
                            widget.entry.createdAt,
                            l10n,
                          ),
                          style: const TextStyle(
                            color: DashboardPalette.mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.close,
                    onPressed: isBusy
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: DashboardPalette.deepText,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              EntryMoodSelector(
                selectedScore: _selectedScore,
                onSelected: isBusy
                    ? (_) {}
                    : (score) => setState(() => _selectedScore = score),
              ),
              const SizedBox(height: 18),
              TextField(
                key: const ValueKey('entry_detail_note_field'),
                controller: _noteController,
                enabled: !isBusy,
                minLines: 4,
                maxLines: 7,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: l10n.notePrefix.trim(),
                  hintText: l10n.addContextForMood,
                  filled: true,
                  fillColor: DashboardPalette.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _SectionTitle(
                title: l10n.reasons,
                trailing: widget.activityOptions == null
                    ? null
                    : l10n.selectedCount(_selectedActivityIds.length),
              ),
              const SizedBox(height: 10),
              _ActivityEditor(
                activityOptions: widget.activityOptions,
                selectedActivityIds: _selectedActivityIds,
                fallbackNames: widget.entry.activityNames,
                enabled: !isBusy,
                onToggle: _toggleActivity,
              ),
              const SizedBox(height: 18),
              _SectionTitle(
                title: l10n.emotions,
                trailing: l10n.selectedCount(_selectedSubEmotionIds.length),
              ),
              const SizedBox(height: 10),
              _SubEmotionEditor(
                moodScore: _selectedScore,
                selectedSubEmotionIds: _selectedSubEmotionIds,
                enabled: !isBusy,
                onToggle: _toggleSubEmotion,
              ),
              const SizedBox(height: 18),
              _SectionTitle(title: l10n.attachments),
              const SizedBox(height: 10),
              _AttachmentEditor(
                photoRelativePath: _photoRelativePath,
                voiceNotePath: _voiceNotePath,
                enabled: !isBusy,
                onPickPhoto: _pickPhoto,
                onRemovePhoto: () => setState(() => _photoRelativePath = null),
                onRemoveVoice: () => setState(() => _voiceNotePath = null),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const ValueKey('entry_detail_delete_button'),
                      onPressed: isBusy ? null : _confirmDelete,
                      icon: _isDeleting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete_outline_rounded),
                      label: Text(l10n.delete),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: moodColor(1),
                        side: BorderSide(color: moodColor(1)),
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      key: const ValueKey('entry_detail_save_button'),
                      onPressed: isBusy ? null : _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: DashboardPalette.purple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await widget.onUpdateEntry(
      id: widget.entry.id,
      moodScore: _selectedScore,
      note: _noteController.text.trim(),
      voiceNotePath: _voiceNotePath,
      photoRelativePath: _photoRelativePath,
      activityIds: _selectedActivityIds.toList(growable: false),
      subEmotionIds: _selectedSubEmotionIds.toList(growable: false),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.deleteEntryQuestion),
          content: Text(l10n.deleteEntryBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              key: const ValueKey('entry_detail_confirm_delete_button'),
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: moodColor(1),
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    setState(() => _isDeleting = true);
    await widget.onDeleteEntry(widget.entry.id);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _toggleActivity(int activityId) {
    setState(() {
      if (!_selectedActivityIds.add(activityId)) {
        _selectedActivityIds.remove(activityId);
      }
    });
  }

  void _toggleSubEmotion(int subEmotionId) {
    setState(() {
      if (!_selectedSubEmotionIds.add(subEmotionId)) {
        _selectedSubEmotionIds.remove(subEmotionId);
      }
    });
  }

  Future<void> _pickPhoto() async {
    final path = await widget.mediaService?.pickPhoto();
    if (path == null || !mounted) return;
    setState(() => _photoRelativePath = path);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}

class _ActivityEditor extends StatelessWidget {
  const _ActivityEditor({
    required this.activityOptions,
    required this.selectedActivityIds,
    required this.fallbackNames,
    required this.enabled,
    required this.onToggle,
  });

  final Stream<List<MoodActivity>>? activityOptions;
  final Set<int> selectedActivityIds;
  final List<String> fallbackNames;
  final bool enabled;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final stream = activityOptions;
    if (stream == null) {
      return _FallbackChipWrap(names: fallbackNames);
    }

    return StreamBuilder<List<MoodActivity>>(
      stream: stream,
      builder: (context, snapshot) {
        final activities = snapshot.data ?? const <MoodActivity>[];
        if (activities.isEmpty && fallbackNames.isNotEmpty) {
          return _FallbackChipWrap(names: fallbackNames);
        }
        if (activities.isEmpty) {
          return Text(
            context.l10n.noReasonsAvailable,
            style: const TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 12,
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final activity in activities)
              FilterChip(
                key: ValueKey('entry_detail_activity_${activity.id}'),
                label: Text(context.l10n.activityLabel(activity.name)),
                selected: selectedActivityIds.contains(activity.id),
                onSelected: enabled ? (_) => onToggle(activity.id) : null,
                selectedColor: DashboardPalette.lilacPanel,
                checkmarkColor: DashboardPalette.purple,
              ),
          ],
        );
      },
    );
  }
}

class _SubEmotionEditor extends StatelessWidget {
  const _SubEmotionEditor({
    required this.moodScore,
    required this.selectedSubEmotionIds,
    required this.enabled,
    required this.onToggle,
  });

  final int moodScore;
  final Set<int> selectedSubEmotionIds;
  final bool enabled;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = subEmotionOptions.where((emotion) {
      return emotion.parentMoodScore == moodScore ||
          selectedSubEmotionIds.contains(emotion.id);
    });

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final emotion in options)
          FilterChip(
            key: ValueKey('entry_detail_sub_emotion_${emotion.id}'),
            label: Text(l10n.subEmotionLabel(emotion.id, emotion.label)),
            selected: selectedSubEmotionIds.contains(emotion.id),
            onSelected: enabled ? (_) => onToggle(emotion.id) : null,
            selectedColor: moodColor(moodScore).withValues(alpha: 0.22),
            checkmarkColor: moodColor(moodScore),
          ),
      ],
    );
  }
}

class _AttachmentEditor extends StatelessWidget {
  const _AttachmentEditor({
    required this.photoRelativePath,
    required this.voiceNotePath,
    required this.enabled,
    required this.onPickPhoto,
    required this.onRemovePhoto,
    required this.onRemoveVoice,
  });

  final String? photoRelativePath;
  final String? voiceNotePath;
  final bool enabled;
  final VoidCallback onPickPhoto;
  final VoidCallback onRemovePhoto;
  final VoidCallback onRemoveVoice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              key: const ValueKey('entry_detail_pick_photo_button'),
              avatar: const Icon(Icons.photo_outlined, size: 18),
              label: Text(
                photoRelativePath == null ? l10n.addPhoto : l10n.replacePhoto,
              ),
              onPressed: enabled ? onPickPhoto : null,
            ),
            if (photoRelativePath != null)
              InputChip(
                key: const ValueKey('entry_detail_photo_chip'),
                avatar: const Icon(Icons.image_outlined, size: 18),
                label: Text(l10n.photoAttached),
                deleteIcon: const Icon(
                  Icons.close_rounded,
                  key: ValueKey('entry_detail_remove_photo_button'),
                ),
                onDeleted: enabled ? onRemovePhoto : null,
              ),
            if (voiceNotePath != null)
              InputChip(
                key: const ValueKey('entry_detail_voice_chip'),
                avatar: const Icon(Icons.graphic_eq_rounded, size: 18),
                label: Text(l10n.voiceAttached),
                deleteIcon: const Icon(
                  Icons.close_rounded,
                  key: ValueKey('entry_detail_remove_voice_button'),
                ),
                onDeleted: enabled ? onRemoveVoice : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _FallbackChipWrap extends StatelessWidget {
  const _FallbackChipWrap({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) {
      return Text(
        context.l10n.noReasonsSelected,
        style: const TextStyle(color: DashboardPalette.mutedText, fontSize: 12),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final name in names)
          Chip(
            label: Text(context.l10n.activityLabel(name)),
            backgroundColor: DashboardPalette.lilacPanel,
          ),
      ],
    );
  }
}
