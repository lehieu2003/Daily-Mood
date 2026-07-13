import 'package:equatable/equatable.dart';

enum DeleteAllDataStatus { idle, deleting, success, failure }

class DeleteAllDataState extends Equatable {
  const DeleteAllDataState({required this.status, this.errorMessage});

  const DeleteAllDataState.idle() : this(status: DeleteAllDataStatus.idle);

  const DeleteAllDataState.deleting()
    : this(status: DeleteAllDataStatus.deleting);

  const DeleteAllDataState.success()
    : this(status: DeleteAllDataStatus.success);

  const DeleteAllDataState.failure(String message)
    : this(status: DeleteAllDataStatus.failure, errorMessage: message);

  final DeleteAllDataStatus status;
  final String? errorMessage;

  bool get isDeleting => status == DeleteAllDataStatus.deleting;
  bool get isSuccess => status == DeleteAllDataStatus.success;

  @override
  List<Object?> get props => [status, errorMessage];
}
