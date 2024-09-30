import 'package:news/data/models/appLanguageModel.dart';
import 'package:news/utils/strings.dart';

class AppSystemSettingModel {
  String? breakNewsMode, liveStreamMode, catMode, subCatMode, commentMode, inAppAdsMode, iosInAppAdsMode, adsType, iosAdsType;
  String? fbRewardedId, fbInterId, fbBannerId, fbNativeId;
  String? fbIOSRewardedId, fbIOSInterId, fbIOSBannerId, fbIOSNativeId;
  String? goRewardedId, goInterId, goBannerId, goNativeId;
  String? goIOSRewardedId, goIOSInterId, goIOSBannerId, goIOSNativeId;
  String? gameId, iosGameId;
  String? unityRewardedId, unityInterId, unityBannerId, unityIOSRewardedId, unityIOSInterId, unityIOSBannerId;
  String? locationWiseNewsMode, weatherMode, maintenanceMode;
  LanguageModel? defaultLangDataModel;

  AppSystemSettingModel(
      {this.breakNewsMode,
      this.liveStreamMode,
      this.catMode,
      this.subCatMode,
      this.commentMode,
      this.inAppAdsMode,
      this.iosInAppAdsMode,
      this.adsType,
      this.iosAdsType,
      this.fbRewardedId,
      this.fbInterId,
      this.fbBannerId,
      this.fbNativeId,
      this.fbIOSBannerId,
      this.fbIOSInterId,
      this.fbIOSNativeId,
      this.fbIOSRewardedId,
      this.goRewardedId,
      this.goBannerId,
      this.goInterId,
      this.goNativeId,
      this.goIOSBannerId,
      this.goIOSInterId,
      this.goIOSNativeId,
      this.goIOSRewardedId,
      this.gameId,
      this.iosGameId,
      this.unityRewardedId,
      this.unityInterId,
      this.unityBannerId,
      this.unityIOSRewardedId,
      this.unityIOSInterId,
      this.unityIOSBannerId,
      this.defaultLangDataModel,
      this.locationWiseNewsMode,
      this.weatherMode,
      this.maintenanceMode});

  factory AppSystemSettingModel.fromJson(Map<String, dynamic> json) {
    var defaultList = (json[DEFAULT_LANG]);

    LanguageModel defaultLangData;
    if (defaultList == null && defaultList.isEmpty) {
      defaultLangData = LanguageModel();
    } else {
      defaultLangData = LanguageModel.fromJson(defaultList);
    }

    return AppSystemSettingModel(
        breakNewsMode: json[BREAK_NEWS_MODE],
        liveStreamMode: json[LIVE_STREAM_MODE],
        catMode: json[CATEGORY_MODE],
        subCatMode: json[SUBCAT_MODE],
        commentMode: json[COMM_MODE],
        inAppAdsMode: json[ADS_MODE],
        iosInAppAdsMode: json[IOS_ADS_MODE],
        adsType: json[ADS_TYPE],
        iosAdsType: json[IOS_ADS_TYPE],
        fbRewardedId: json[FB_REWARDED_ID] ?? "",
        fbInterId: json[FB_INTER_ID],
        fbBannerId: json[FB_BANNER_ID],
        fbNativeId: json[FB_NATIVE_ID],
        fbIOSRewardedId: json[IOS_FB_REWARDED_ID],
        fbIOSNativeId: json[IOS_FB_NATIVE_ID],
        fbIOSInterId: json[IOS_FB_INTER_ID],
        fbIOSBannerId: json[IOS_FB_BANNER_ID],
        goRewardedId: json[GO_REWARDED_ID],
        goInterId: json[GO_INTER_ID],
        goBannerId: json[GO_BANNER_ID],
        goNativeId: json[GO_NATIVE_ID],
        goIOSRewardedId: json[IOS_GO_REWARDED_ID],
        goIOSNativeId: json[IOS_GO_NATIVE_ID],
        goIOSInterId: json[IOS_GO_INTER_ID],
        goIOSBannerId: json[IOS_GO_BANNER_ID],
        gameId: json[U_AND_GAME_ID],
        iosGameId: json[IOS_U_GAME_ID],
        unityRewardedId: json[U_REWARDED_ID],
        unityInterId: json[U_INTER_ID],
        unityBannerId: json[U_BANNER_ID],
        unityIOSRewardedId: json[IOS_U_REWARDED_ID],
        unityIOSInterId: json[IOS_U_INTER_ID],
        unityIOSBannerId: json[IOS_U_BANNER_ID],
        defaultLangDataModel: defaultLangData,
        locationWiseNewsMode: json[LOCATION_WISE_NEWS_MODE],
        weatherMode: json[WEATHER_MODE],
        maintenanceMode: json[MAINTENANCE_MODE]);
  }
}
