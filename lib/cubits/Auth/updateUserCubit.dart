import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/Auth/authCubit.dart';
import 'package:news/data/models/AuthModel.dart';
import 'package:news/data/repositories/Auth/authRepository.dart';

abstract class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserFetchInProgress extends UpdateUserState {}

class UpdateUserFetchSuccess extends UpdateUserState {
  AuthModel? updatedUser;
  String? imgUpdatedPath;

  UpdateUserFetchSuccess({this.updatedUser, this.imgUpdatedPath});
}

class UpdateUserFetchFailure extends UpdateUserState {
  final String errorMessage;

  UpdateUserFetchFailure(this.errorMessage);
}

class UpdateUserCubit extends Cubit<UpdateUserState> {
  final AuthRepository _updateUserRepository;

  UpdateUserCubit(this._updateUserRepository) : super(UpdateUserInitial());

  void setUpdateUser({String? name, String? mobile, String? email, String? filePath, required BuildContext context}) async {
    try {
      emit(UpdateUserFetchInProgress());
      final Map<String, dynamic> result = await _updateUserRepository.updateUserData(mobile: mobile, name: name, email: email, filePath: filePath);
      //only incase of name,mobile & mail, not Profile Picture
      context.read<AuthCubit>().updateDetails(authModel: AuthModel.fromJson(result["data"]));
      emit(UpdateUserFetchSuccess(updatedUser: AuthModel.fromJson(result["data"])));
    } catch (e) {
      emit(UpdateUserFetchFailure(e.toString()));
    }
  }
}
