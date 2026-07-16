import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/localization/app_localizations.dart';
import '../state/delete_all_data_cubit.dart';
import '../state/delete_all_data_state.dart';

class DeleteAllDataDialog extends StatefulWidget {
  const DeleteAllDataDialog({required this.onDeleted, super.key});

  final VoidCallback onDeleted;

  @override
  State<DeleteAllDataDialog> createState() => _DeleteAllDataDialogState();
}

class _DeleteAllDataDialogState extends State<DeleteAllDataDialog> {
  static const _confirmationText = 'DELETE';

  final _controller = TextEditingController();
  bool _canDelete = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirmationChanged(String value) {
    setState(() => _canDelete = value.trim() == _confirmationText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocConsumer<DeleteAllDataCubit, DeleteAllDataState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.isSuccess) {
          widget.onDeleted();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text(l10n.deleteAllLocalData),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteAllLocalDataBody),
              const SizedBox(height: 12),
              Text(
                l10n.typeDeleteToConfirm,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const ValueKey('delete_all_data_confirmation_field'),
                controller: _controller,
                enabled: !state.isDeleting,
                textCapitalization: TextCapitalization.characters,
                onChanged: _onConfirmationChanged,
                decoration: const InputDecoration(hintText: 'DELETE'),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: state.isDeleting
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              key: const ValueKey('delete_all_data_confirm_button'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: !_canDelete || state.isDeleting
                  ? null
                  : context.read<DeleteAllDataCubit>().deleteAllData,
              child: state.isDeleting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}
