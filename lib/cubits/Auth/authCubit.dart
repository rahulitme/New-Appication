import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/models/AuthModel.dart';
import 'package:news/data/repositories/Auth/authRepository.dart';

const String loginEmail = "email";
const String loginGmail = "gmail";
const String loginFb = "fb";
const String loginMbl = "mobile";
const String loginApple = "apple";

enum AuthProviders { gmail, fb, apple, mobile, email }

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  //to store authDetails
  final AuthModel authModel;

  Authenticated({required this.authModel});
}

class Unauthenticated extends AuthState {}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    checkAuthStatus();
  }

  AuthRepository get authRepository => _authRepository;

  void checkAuthStatus() {
    //authDetails is map. keys are isLogin,userId,authProvider
    final authDetails = _authRepository.getLocalAuthDetails();

    (authDetails['isLogIn']) ? emit(Authenticated(authModel: AuthModel.fromJson(authDetails))) : emit(Unauthenticated());
  }

  String getUserId() {
    return (state is Authenticated) ? (state as Authenticated).authModel.id! : "0";
  }

  String getProfile() {
    return (state is Authenticated)
        ? ((state as Authenticated).authModel.profile!.trim().isNotEmpty)
            ? (state as Authenticated).authModel.profile!
            : ""
        : "";
  }

  String getMobile() {
    return (state is Authenticated) ? (state as Authenticated).authModel.mobile! : "";
  }

  String getType() {
    return (state is Authenticated) ? (state as Authenticated).authModel.type! : "";
  }

  String getRole() {
    return (state is Authenticated) ? (state as Authenticated).authModel.role! : "";
  }

  void updateDetails({required AuthModel authModel}) {
    emit(Authenticated(authModel: authModel));
  }

  Future signOut(AuthProviders authProvider) async {
    if (state is Authenticated) {
      _authRepository.signOut(authProvider);
      emit(Unauthenticated());
    }
  }
}
