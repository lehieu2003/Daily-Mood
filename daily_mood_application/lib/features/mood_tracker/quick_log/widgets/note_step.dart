import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_typography.dart';
import '../../cubit/mood_form_cubit.dart';
import '../../cubit/mood_form_state.dart';

class NoteStep extends StatelessWidget {
  const NoteStep({required this.state, super.key});

  final MoodFormState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: state.note,
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
        OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.mic, size: 18),
          label: const Text('Record voice note'),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            disabledForegroundColor: Colors.black,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
