import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:news/app/routes.dart';
import 'package:news/cubits/appLocalizationCubit.dart';
import 'package:news/cubits/generalNewsCubit.dart';
import 'package:news/data/models/NewsModel.dart';
import 'package:news/data/repositories/Settings/settingsLocalDataRepository.dart';
import 'package:news/ui/styles/colors.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/ui/widgets/networkImage.dart';
import 'package:news/utils/uiUtils.dart';

class GeneralNewsRandomStyle extends StatefulWidget {
  final List<NewsModel> modelList;

  const GeneralNewsRandomStyle({super.key, required this.modelList});

  @override
  GeneralNewsRandomStyleState createState() => GeneralNewsRandomStyleState();
}

class GeneralNewsRandomStyleState extends State<GeneralNewsRandomStyle> {
  late final ScrollController scrollController = ScrollController()..addListener(hasMoreGeneralNewsListener);
  late int counter; //counter will handle unique index in both list & grid
  late List<NewsModel> newsList;
  @override
  void initState() {
    super.initState();
    newsList = widget.modelList;
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void hasMoreGeneralNewsListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (context.read<GeneralNewsCubit>().hasMoreGeneralNews()) {
        context.read<GeneralNewsCubit>().getMoreGeneralNews(
            langId: context.read<AppLocalizationCubit>().state.id,
            latitude: SettingsLocalDataRepository().getLocationCityValues().first,
            longitude: SettingsLocalDataRepository().getLocationCityValues().last);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    counter = 0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsList.length,
          separatorBuilder: (BuildContext context, int index) {
            return (index.isOdd && counter + 1 < newsList.length) ? getGrid() : const SizedBox.shrink(); //return blank widget
          },
          itemBuilder: (BuildContext context, int index) {
            return (counter < newsList.length) ? listRow(counter++) : const SizedBox.shrink(); //return blank widget
          },
        ),
      ],
    );
  }

  Widget getGrid() {
    return SizedBox(
        height: 200,
        child: GridView.count(
            crossAxisCount: 1,
            scrollDirection: Axis.horizontal,
            children: List.generate((counter % 3 == 0) ? 3 : 2, (index) {
              return Padding(padding: const EdgeInsets.only(right: 15), child: listRow((counter < newsList.length) ? counter++ : counter));
            })));
  }

  Widget listRow(int index) {
    NewsModel newsModel = newsList[index];
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
          onTap: () {
            List<NewsModel> newList = [];
            newList.addAll(newsList);
            newList.removeAt(index);
            Navigator.of(context).pushNamed(Routes.newsDetails, arguments: {"model": newsList[index], "newsList": newList, "isFromBreak": false, "fromShowMore": false});
          },
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ShaderMask(
                      shaderCallback: (rect) =>
                          LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Colors.transparent, darkSecondaryColor.withOpacity(0.9)]).createShader(rect),
                      blendMode: BlendMode.darken,
                      child: CustomNetworkImage(
                          networkImageUrl: newsModel.image!,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height / 3.3,
                          isVideo: newsModel.type == 'videos' ? true : false))),
              if (newsModel.type == 'videos')
                Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: MediaQuery.of(context).size.height * 0.12,
                    start: MediaQuery.of(context).size.width / 3,
                    end: MediaQuery.of(context).size.width / 3,
                    child: InkWell(onTap: () => Navigator.of(context).pushNamed(Routes.newsVideo, arguments: {"from": 1, "model": newsModel}), child: UiUtils.setPlayButton(context: context))),
              Positioned.directional(
                  textDirection: Directionality.of(context),
                  bottom: 10,
                  start: 10,
                  end: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (newsModel.categoryName != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: CustomTextLabel(
                                    text: newsModel.categoryName!,
                                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor.withOpacity(0.6)),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true)),
                          ),
                        ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: CustomTextLabel(
                              text: newsModel.title!,
                              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: secondaryColor, fontWeight: FontWeight.normal),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true)),
                    ],
                  ))
            ],
          )),
    );
  }
}
