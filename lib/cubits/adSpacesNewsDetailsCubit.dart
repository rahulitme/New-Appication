import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/models/adSpaceModel.dart';
import 'package:news/utils/api.dart';
import 'package:news/utils/strings.dart';

abstract class AdSpacesNewsDetailsState {}

class AdSpacesNewsDetailsInitial extends AdSpacesNewsDetailsState {}

class AdSpacesNewsDetailsFetchInProgress extends AdSpacesNewsDetailsState {}

class AdSpacesNewsDetailsFetchSuccess extends AdSpacesNewsDetailsState {
  final AdSpaceModel? adSpaceTopData;
  final AdSpaceModel? adSpaceBottomData;

  AdSpacesNewsDetailsFetchSuccess({this.adSpaceTopData, this.adSpaceBottomData});
}

class AdSpacesNewsDetailsFetchFailure extends AdSpacesNewsDetailsState {
  final String errorMessage;

  AdSpacesNewsDetailsFetchFailure(this.errorMessage);
}

class AdSpacesNewsDetailsCubit extends Cubit<AdSpacesNewsDetailsState> {
  AdSpacesNewsDetailsCubit() : super(AdSpacesNewsDetailsInitial());

  void getAdspaceForNewsDetails({required String langId}) async {
    emit(AdSpacesNewsDetailsFetchInProgress());
    try {
      final body = {LANGUAGE_ID: langId};
      final Map<String, dynamic> result = await Api.sendApiRequest(body: body, url: Api.getAdsNewsDetailsApi, isGet: true);
      final Map<String, dynamic> resultData = result[DATA];
      emit(AdSpacesNewsDetailsFetchSuccess(
          adSpaceTopData: (resultData.containsKey('ad_spaces_top')) ? (AdSpaceModel.fromJson(resultData['ad_spaces_top'])) : null,
          adSpaceBottomData: (resultData.containsKey('ad_spaces_bottom')) ? AdSpaceModel.fromJson(resultData['ad_spaces_bottom']) : null));
    } catch (e) {
      emit(AdSpacesNewsDetailsFetchFailure(e.toString()));
    }
  }
}
