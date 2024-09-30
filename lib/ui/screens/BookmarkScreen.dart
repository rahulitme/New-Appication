import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/app/routes.dart';
import 'package:news/cubits/appLocalizationCubit.dart';
import 'package:news/cubits/Bookmark/bookmarkCubit.dart';
import 'package:news/data/models/NewsModel.dart';
import 'package:news/ui/styles/colors.dart';
import 'package:news/ui/widgets/customAppBar.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/ui/widgets/errorContainerWidget.dart';
import 'package:news/ui/widgets/networkImage.dart';
import 'package:news/ui/widgets/shimmerNewsList.dart';
import 'package:news/utils/ErrorMessageKeys.dart';
import 'package:news/utils/internetConnectivity.dart';
import 'package:news/utils/uiUtils.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  BookmarkScreenState createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {
  late final ScrollController _controller = ScrollController()..addListener(hasMoreBookmarkScrollListener);

  @override
  void initState() {
    super.initState();
    getBookMark();
  }

  void getBookMark() async {
    if (await InternetConnectivity.isNetworkAvailable()) {
      Future.delayed(Duration.zero, () {
        context.read<BookmarkCubit>().getBookmark(langId: context.read<AppLocalizationCubit>().state.id);
      });
    }
  }

  void hasMoreBookmarkScrollListener() {
    if (_controller.position.maxScrollExtent == _controller.offset) {
      if (context.read<BookmarkCubit>().hasMoreBookmark()) {
        context.read<BookmarkCubit>().getMoreBookmark(langId: context.read<AppLocalizationCubit>().state.id);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: setCustomAppBar(height: 45, isBackBtn: true, label: 'bookmarkLbl', context: context, horizontalPad: 15, isConvertText: true),
        body: Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 10.0),
            child: BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, state) {
                if (state is BookmarkFetchSuccess && state.bookmark.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 15.0, end: 15.0, top: 10.0, bottom: 10.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        getBookMark();
                      },
                      child: ListView.builder(
                          controller: _controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.bookmark.length,
                          itemBuilder: (context, index) {
                            return _buildBookmarkContainer(model: state.bookmark[index], hasMore: state.hasMore, hasMoreBookFetchError: state.hasMoreFetchError, index: index, totalCurrentBook: 6);
                          }),
                    ),
                  );
                } else if (state is BookmarkFetchFailure || ((state is! BookmarkFetchInProgress))) {
                  if (state is BookmarkFetchFailure) {
                    return ErrorContainerWidget(
                        errorMsg: (state.errorMessage.contains(ErrorMessageKeys.noInternet)) ? UiUtils.getTranslatedLabel(context, 'internetmsg') : state.errorMessage, onRetry: getBookMark);
                  } else {
                    return const Center(child: CustomTextLabel(text: 'bookmarkNotAvail', textAlign: TextAlign.center));
                  }
                }
                //default/Processing state
                return Padding(padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0), child: shimmerNewsList(context, isNews: false));
              },
            )));
  }

  _buildBookmarkContainer({required NewsModel model, required int index, required int totalCurrentBook, required bool hasMoreBookFetchError, required bool hasMore}) {
    if (index == totalCurrentBook - 1 && index != 0 && hasMore) {
      if (hasMoreBookFetchError) {
        return Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: IconButton(
                    onPressed: () {
                      context.read<BookmarkCubit>().getMoreBookmark(langId: context.read<AppLocalizationCubit>().state.id);
                    },
                    icon: Icon(Icons.error, color: Theme.of(context).primaryColor))));
      }
    }

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4.2,
        child: InkWell(
          child: Stack(
            children: [
              Positioned.directional(
                  textDirection: Directionality.of(context),
                  bottom: 0,
                  start: 0,
                  end: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [darkSecondaryColor.withOpacity(0.01), darkSecondaryColor.withOpacity(0.75)])
                            .createShader(bounds);
                      },
                      blendMode: BlendMode.darken,
                      child: CustomNetworkImage(networkImageUrl: model.image!, height: MediaQuery.of(context).size.height / 4.2, width: double.maxFinite, fit: BoxFit.cover, isVideo: false),
                    ),
                  )),
              Container(
                color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 5),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomTextLabel(
                              text: UiUtils.convertToAgo(context, DateTime.parse(model.publishDate ?? model.date!), 0)!,
                              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600)),
                          Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomTextLabel(
                                  text: model.title!,
                                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: secondaryColor, fontWeight: FontWeight.w600, fontSize: 15, height: 1.0, letterSpacing: 0.5),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis))
                        ],
                      ),
                    )),
              ),
            ],
          ),
          onTap: () async {
            //Interstitial Ad here
            UiUtils.showInterstitialAds(context: context);
            Navigator.of(context).pushNamed(Routes.newsDetails, arguments: {"model": model, "isFromBreak": false, "fromShowMore": false});
          },
        ),
      ),
    );
  }
}
