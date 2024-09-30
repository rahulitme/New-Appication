import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/utils/strings.dart';
import 'package:news/data/models/AuthModel.dart';
import 'package:news/data/repositories/Auth/authRepository.dart';
import 'package:news/cubits/Auth/authCubit.dart';

@immutable
abstract class SocialSignUpState {}

class SocialSignUpInitial extends SocialSignUpState {}

class SocialSignUpProgress extends SocialSignUpState {}

class SocialSignUpSuccess extends SocialSignUpState {
  final AuthModel authModel;

  SocialSignUpSuccess({required this.authModel});
}

class SocialSignUpFailure extends SocialSignUpState {
  final String errorMessage;

  SocialSignUpFailure(this.errorMessage);
}

class SocialSignUpCubit extends Cubit<SocialSignUpState> {
  final AuthRepository _authRepository;

  SocialSignUpCubit(this._authRepository) : super(SocialSignUpInitial());

  void socialSignUpUser({required AuthProviders authProvider, required BuildContext context, String? email, String? password, String? otp, String? verifiedId}) {
    emit(SocialSignUpProgress());
    _authRepository.signInUser(email: email, otp: otp, password: password, verifiedId: verifiedId, authProvider: authProvider, context: context).then((result) {
      emit(SocialSignUpSuccess(authModel: AuthModel.fromJson(result[DATA])));
    }).catchError((e) {
      emit(SocialSignUpFailure(e.toString()));
    });
  }
}
