import 'package:flutter/material.dart';

import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';
import '../entry_detail_actions.dart';
import 'entry_mood_selector.dart';

Future<void> showEntryDetailSheet({
  required BuildContext context,
  required MoodEntryModel entry,
  required EntryUpdateAction onUpdateEntry,
  required EntryDeleteAction onDeleteEntry,
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
  });

  final MoodEntryModel entry;
  final EntryUpdateAction onUpdateEntry;
  final EntryDeleteAction onDeleteEntry;

  @override
  State<EntryDetailSheet> createState() => _EntryDetailSheetState();
}

class _EntryDetailSheetState extends State<EntryDetailSheet> {
  late int _selectedScore;
  late final TextEditingController _noteController;
  var _isSaving = false;
  var _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _selectedScore = widget.entry.moodScore;
    _noteController = TextEditingController(text: widget.entry.note ?? '');
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
                          moodLabel(_selectedScore),
                          style: const TextStyle(
                            color: DashboardPalette.deepText,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatEntryDate(widget.entry.createdAt),
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
                    tooltip: 'Close',
                    onPressed: isBusy ? null : () => Navigator.of(context).pop(),
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
                  labelText: 'Note',
                  hintText: 'Add context for this mood',
                  filled: true,
                  fillColor: DashboardPalette.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
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
                      label: const Text('Delete'),
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
                          : const Text('Save'),
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
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete entry?'),
          content: const Text(
            'This hides the entry from your dashboard and history.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const ValueKey('entry_detail_confirm_delete_button'),
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: moodColor(1),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
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
}
