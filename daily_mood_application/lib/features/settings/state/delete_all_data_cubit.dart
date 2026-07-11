import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/local_data_reset_service.dart';
import 'delete_all_data_state.dart';

class DeleteAllDataCubit extends Cubit<DeleteAllDataState> {
  DeleteAllDataCubit({required LocalDataResetService resetService})
    : _resetService = resetService,
      super(const DeleteAllDataState.idle());

  final LocalDataResetService _resetService;

  Future<void> deleteAllData() async {
    if (state.isDeleting) return;
    emit(const DeleteAllDataState.deleting());
    try {
      await _resetService.deleteAllData();
      emit(const DeleteAllDataState.success());
    } catch (_) {
      emit(
        const DeleteAllDataState.failure(
          'Could not delete local data. Please try again.',
        ),
      );
    }
  }
}
