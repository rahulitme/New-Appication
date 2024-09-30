import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/repositories/DeleteUserNotification/deleteUserNotiRepository.dart';
import 'package:news/utils/api.dart';

abstract class DeleteUserNotiState {}

class DeleteUserNotiInitial extends DeleteUserNotiState {}

class DeleteUserNotiInProgress extends DeleteUserNotiState {}

class DeleteUserNotiSuccess extends DeleteUserNotiState {
  final String message;

  DeleteUserNotiSuccess(this.message);
}

class DeleteUserNotiFailure extends DeleteUserNotiState {
  final String errorMessage;

  DeleteUserNotiFailure(this.errorMessage);
}

class DeleteUserNotiCubit extends Cubit<DeleteUserNotiState> {
  final DeleteUserNotiRepository _deleteUserNotiRepository;

  DeleteUserNotiCubit(this._deleteUserNotiRepository) : super(DeleteUserNotiInitial());

  void deleteUserNotification({required String id}) {
    emit(DeleteUserNotiInProgress());
    _deleteUserNotiRepository.deleteUserNotification(id: id).then((value) {
      emit(DeleteUserNotiSuccess(value["message"]));
    }).catchError((e) {
      ApiMessageAndCodeException apiMessageAndCodeException = e;
      emit(DeleteUserNotiFailure(apiMessageAndCodeException.errorMessage.toString()));
    });
  }
}
