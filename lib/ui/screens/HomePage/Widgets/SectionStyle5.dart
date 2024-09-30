import 'dart:math';

import 'package:news/ui/screens/HomePage/Widgets/CommonSectionTitle.dart';
import 'package:flutter/material.dart';
import 'package:news/app/routes.dart';
import 'package:news/data/models/BreakingNewsModel.dart';
import 'package:news/data/models/FeatureSectionModel.dart';
import 'package:news/data/models/NewsModel.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/utils/constant.dart';
import 'package:news/utils/uiUtils.dart';
import 'package:news/ui/styles/colors.dart';
import 'package:news/ui/widgets/networkImage.dart';

class Style5Section extends StatelessWidget {
  final FeatureSectionModel model;

  const Style5Section({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return style5Data(model, context);
  }

  Widget style5SingleNewsData(FeatureSectionModel model, BuildContext context) {
    NewsModel data = (model.newsType == 'news' || model.newsType == "user_choice") ? model.news![0] : model.videos![0];
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: double.maxFinite,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CustomNetworkImage(
                  networkImageUrl: data.image!, height: MediaQuery.of(context).size.height * 0.28, width: double.maxFinite, fit: BoxFit.cover, isVideo: model.newsType == 'videos' ? true : false),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.categoryName != null)
                      Container(
                          height: 20.0,
                          padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8.0, top: 2.5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColor),
                          child: CustomTextLabel(
                              text: data.categoryName!,
                              textAlign: TextAlign.left,
                              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true)),
                    Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                        child: CustomTextLabel(
                            text: data.title!,
                            textAlign: TextAlign.left,
                            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: secondaryColor, fontWeight: FontWeight.w700),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true)),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_month, color: secondaryColor, size: 20),
                          Padding(
                              padding: const EdgeInsetsDirectional.only(start: 10),
                              child: CustomTextLabel(
                                  text: UiUtils.convertToAgo(context, DateTime.parse(data.publishDate ?? data.date!), 0)!,
                                  textAlign: TextAlign.left,
                                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true)),
                        ],
                      ),
                    ),
                    if (model.newsType == 'videos')
                      InkWell(
                        child: Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02), child: UiUtils.setPlayButton(context: context)),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.newsVideo, arguments: {"from": 1, "model": data});
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (model.newsType == 'news' || model.newsType == "user_choice") {
          List<NewsModel> newsList = [];
          newsList.addAll(model.news!);
          newsList.removeAt(0);
          Navigator.of(context).pushNamed(Routes.newsDetails, arguments: {"model": data, "newsList": newsList, "isFromBreak": false, "fromShowMore": false});
        }
      },
    );
  }

  Widget style5SingleBreakNewsData(FeatureSectionModel model, BuildContext context) {
    BreakingNewsModel data = model.newsType == 'breaking_news' ? model.breakNews![0] : model.breakVideos![0];
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: double.maxFinite,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, darkSecondaryColor.withOpacity(0.9)]).createShader(rect),
                blendMode: BlendMode.darken,
                child: CustomNetworkImage(
                    networkImageUrl: data.image!, height: MediaQuery.of(context).size.height * 0.28, width: double.maxFinite, fit: BoxFit.cover, isVideo: model.newsType == 'videos' ? true : false),
              ),
            ),
            (model.newsType == 'videos')
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                child: CustomTextLabel(
                                    text: data.title!,
                                    textAlign: TextAlign.left,
                                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: secondaryColor, fontWeight: FontWeight.w700),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true)),
                            InkWell(
                              child: Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02), child: UiUtils.setPlayButton(context: context)),
                              onTap: () {
                                Navigator.of(context).pushNamed(Routes.newsVideo, arguments: {"from": 3, "breakModel": data});
                              },
                            ),
                          ],
                        )),
                  )
                : Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: CustomTextLabel(
                            text: data.title!,
                            textAlign: TextAlign.left,
                            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: secondaryColor, fontWeight: FontWeight.w700),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true)),
                  ),
          ],
        ),
      ),
      onTap: () {
        if (model.newsType == 'breaking_news') {
          List<BreakingNewsModel> breakList = [];
          breakList.addAll(model.breakNews!);
          breakList.removeAt(0);
          Navigator.of(context).pushNamed(Routes.newsDetails, arguments: {"breakModel": data, "breakNewsList": breakList, "isFromBreak": true, "fromShowMore": false});
        }
      },
    );
  }

  Widget style5Data(FeatureSectionModel model, BuildContext context) {
    int limit = limitOfAllOtherStyle;
    int newsLength = (model.newsType == 'news' || model.newsType == "user_choice") ? model.news!.length : model.videos!.length;
    int brNewsLength = model.newsType == 'breaking_news' ? model.breakNews!.length : model.breakVideos!.length;

    if (model.breakVideos!.isNotEmpty || model.breakNews!.isNotEmpty || model.videos!.isNotEmpty || model.news!.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonSectionTitle(model, context),
          if ((model.newsType == 'news' || model.videosType == "news" || model.newsType == "user_choice") && (model.newsType == 'news' || model.newsType == "user_choice")
              ? model.news!.isNotEmpty
              : model.videos!.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                style5SingleNewsData(model, context),
                if (/* (model.newsType == 'news' || model.newsType == "user_choice") ? model.news!.length > 1 : model.videos!.length > 1 */ newsLength > 1)
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(/* (model.newsType == 'news' || model.newsType == "user_choice") ? model.news!.length : model.videos!.length */ min(newsLength, limit), (index) {
                              if (newsLength /* (model.newsType == 'news' || model.newsType == "user_choice") ? model.news!.length > index + 1 : model.videos!.length */ > index + 1) {
                                NewsModel data = (model.newsType == 'news' || model.newsType == "user_choice") ? model.news![index + 1] : model.videos![index + 1];
                                return InkWell(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.35,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CustomNetworkImage(
                                                  networkImageUrl: data.image!,
                                                  height: MediaQuery.of(context).size.height * 0.15,
                                                  width: MediaQuery.of(context).size.width / 2.35,
                                                  fit: BoxFit.cover,
                                                  isVideo: model.newsType == 'videos' ? true : false),
                                            ),
                                            if (data.categoryName != null)
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    margin: const EdgeInsetsDirectional.only(start: 7.0, top: 7.0),
                                                    height: 18.0,
                                                    padding: const EdgeInsetsDirectional.only(start: 6.0, end: 6.0, top: 2.5),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColor),
                                                    child: CustomTextLabel(
                                                        text: data.categoryName!,
                                                        textAlign: TextAlign.left,
                                                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor),
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: true)),
                                              ),
                                            if (model.newsType == 'videos')
                                              Positioned.directional(
                                                textDirection: Directionality.of(context),
                                                top: MediaQuery.of(context).size.height * 0.058,
                                                start: MediaQuery.of(context).size.width / 8.5,
                                                end: MediaQuery.of(context).size.width / 8.5,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).pushNamed(Routes.newsVideo, arguments: {"from": 1, "model": data});
                                                    },
                                                    child: UiUtils.setPlayButton(context: context, heightVal: 28)),
                                              ),
                                          ]),
                                          Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: CustomTextLabel(
                                                  text: data.title!,
                                                  textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: UiUtils.getColorScheme(context).primaryContainer),
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis)),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.calendar_month, color: UiUtils.getColorScheme(context).primaryContainer, size: 15),
                                                Padding(
                                                    padding: const EdgeInsetsDirectional.only(start: 5),
                                                    child: CustomTextLabel(
                                                        text: UiUtils.convertToAgo(context, DateTime.parse(data.publishDate ?? data.date!), 0)!,
                                                        textAlign: TextAlign.left,
                                                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer),
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: true)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (model.newsType == 'news' || model.newsType == "user_choice") {
                                      List<NewsModel> newsList = [];
                                      newsList.addAll(model.news!);
                                      newsList.removeAt(index + 1);
                                      Navigator.of(context).pushNamed(Routes.newsDetails, arguments: {"model": data, "newsList": newsList, "isFromBreak": false, "fromShowMore": false});
                                    }
                                  },
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            })),
                      )),
              ],
            ),
          if ((model.newsType == 'breaking_news' && model.breakNews?.isNotEmpty == true) || (model.videosType == 'breaking_news' && model.breakVideos?.isNotEmpty == true))
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                style5SingleBreakNewsData(model, context),
                if (brNewsLength > 1)
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(min(brNewsLength, limit), (index) {
                              if (brNewsLength > index + 1) {
                                BreakingNewsModel data = model.newsType == 'breaking_news' ? model.breakNews![index + 1] : model.breakVideos![index + 1];
                                return InkWell(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2.35,
                                    padding: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CustomNetworkImage(
                                                networkImageUrl: data.image!,
                                                height: MediaQuery.of(context).size.height * 0.15,
                                                width: MediaQuery.of(context).size.width / 2.35,
                                                fit: BoxFit.cover,
                                                isVideo: model.newsType == 'videos' ? true : false),
                                          ),
                                          if (model.newsType == 'videos')
                                            Positioned.directional(
                                              textDirection: Directionality.of(context),
                                              top: MediaQuery.of(context).size.height * 0.058,
                                              start: MediaQuery.of(context).size.width / 8.5,
                                              end: MediaQuery.of(context).size.width / 8.5,
                                              child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(Routes.newsVideo, arguments: {"from": 3, "breakModel": data});
                                                  },
                                                  child: UiUtils.setPlayButton(context: context, heightVal: 28)),
                                            ),
                                        ]),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: CustomTextLabel(
                                                text: data.title!,
                                                textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: UiUtils.getColorScheme(context).primaryContainer),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    if (model.newsType == 'breaking_news') {
                                      List<BreakingNewsModel> breakList = [];
                                      breakList.addAll(model.breakNews!);
                                      breakList.removeAt(index + 1);
                                      Navigator.of(context).pushNamed(Routes.newsDetails, arguments: {"breakModel": data, "breakNewsList": breakList, "isFromBreak": true, "fromShowMore": false});
                                    }
                                  },
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            })),
                      )),
              ],
            )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
