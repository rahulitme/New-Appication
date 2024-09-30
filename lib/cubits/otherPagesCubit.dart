import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/models/OtherPageModel.dart';
import 'package:news/data/repositories/OtherPages/otherPagesRepository.dart';

abstract class OtherPageState {}

class OtherPageInitial extends OtherPageState {}

class OtherPageFetchInProgress extends OtherPageState {}

class OtherPageFetchSuccess extends OtherPageState {
  final List<OtherPageModel> otherPage;

  OtherPageFetchSuccess({required this.otherPage});
}

class OtherPageFetchFailure extends OtherPageState {
  final String errorMessage;

  OtherPageFetchFailure(this.errorMessage);
}

class OtherPageCubit extends Cubit<OtherPageState> {
  final OtherPageRepository _otherPageRepository;

  OtherPageCubit(this._otherPageRepository) : super(OtherPageInitial());

  void getOtherPage({required String langId}) async {
    emit(OtherPageFetchInProgress());
    try {
      final result = await _otherPageRepository.getOtherPage(langId: langId);
      emit(OtherPageFetchSuccess(otherPage: result['OtherPage']));
    } catch (e) {
      emit(OtherPageFetchFailure(e.toString()));
    }
  }
}
