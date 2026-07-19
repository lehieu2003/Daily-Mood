import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../domain/models/mood_activity.dart';

class CustomTagsSheet extends StatelessWidget {
  const CustomTagsSheet({super.key, required this.repository});

  final ActivityRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.manageCustomTags, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              l10n.manageCustomTagsBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.55,
              ),
              child: StreamBuilder<List<MoodActivity>>(
                stream: repository.watchCustomActivities(),
                builder: (context, snapshot) {
                  final tags = snapshot.data ?? const <MoodActivity>[];
                  if (tags.isEmpty) {
                    return _CustomTagsEmptyState(message: l10n.noCustomTags);
                  }

                  return ListView.separated(
                    key: const ValueKey('custom_tags_list'),
                    shrinkWrap: true,
                    itemCount: tags.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      return _CustomTagTile(tag: tag, repository: repository);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTagsEmptyState extends StatelessWidget {
  const _CustomTagsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CustomTagTile extends StatelessWidget {
  const _CustomTagTile({required this.tag, required this.repository});

  final MoodActivity tag;
  final ActivityRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final status = tag.isArchived ? l10n.archivedTag : l10n.activeTag;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: ListTile(
        key: ValueKey('custom_tag_${tag.id}'),
        minVerticalPadding: 12,
        leading: Icon(
          tag.isArchived ? Icons.inventory_2_outlined : Icons.label_outline,
          color: tag.isArchived
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.primary,
        ),
        title: Text(
          l10n.activityLabel(tag.name),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text('${l10n.categoryLabel(tag.category)} • $status'),
        trailing: TextButton(
          key: ValueKey(
            tag.isArchived
                ? 'restore_custom_tag_${tag.id}'
                : 'archive_custom_tag_${tag.id}',
          ),
          onPressed: () => _toggleArchive(context),
          child: Text(tag.isArchived ? l10n.restore : l10n.archive),
        ),
      ),
    );
  }

  Future<void> _toggleArchive(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      if (tag.isArchived) {
        await repository.restoreCustomActivity(tag.id);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.customTagRestored(tag.name))),
        );
      } else {
        await repository.archiveCustomActivity(tag.id);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.customTagArchived(tag.name))),
        );
      }
    } catch (_) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.customTagUpdateFailed)),
      );
    }
  }
}
